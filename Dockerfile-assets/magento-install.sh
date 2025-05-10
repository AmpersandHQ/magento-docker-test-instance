#!/bin/bash
# shellcheck source=/dev/null
source /home/ampersand/.bashrc
set -euo pipefail
cd /var/www/html

COMPOSER_REPOSITORY=${COMPOSER_REPOSITORY:-https://repo-magento-mirror.fooman.co.nz/}
FULL_INSTALL=${FULL_INSTALL:-0}
COMPOSER_MODULE_SYMLINK=${COMPOSER_MODULE_SYMLINK:-1}
BASE_DOMAIN="0.0.0.0:$MAGENTO_PORT"
BASE_URL="http://$BASE_DOMAIN"
MAGE_VERSION=${MAGE_VERSION:-0}
TWOFACTOR_ENABLED=${TWOFACTOR_ENABLED:-0}
ELASTICSEARCH_OPTIONS=${ELASTICSEARCH_OPTIONS:-}
COMPOSER_REQUIRE_EXTRA=${COMPOSER_REQUIRE_EXTRA:-0}
COMPOSER_AFTER_INSTALL_COMMAND=${COMPOSER_AFTER_INSTALL_COMMAND:-0}
INTEGRATION_TESTS_PATH=${INTEGRATION_TESTS_PATH:-'src/Test/Integration'}
UNIT_TESTS_PATH=${UNIT_TESTS_PATH:-'src/Test/Unit'}

echo "Setting the required version of PHP"
phpenv global "$PHP_VERSION"
php --version
ln -f -s /home/ampersand/.phpenv/bin/"$COMPOSER_VERSION" /home/ampersand/.phpenv/bin/composer && composer --version

echo "Composer - creating project"
if [ "$MAGE_VERSION" = "0" ]; then
  composer create-project --repository="$COMPOSER_REPOSITORY" magento/project-community-edition /var/www/html --no-install --no-plugins
else
  composer create-project --repository="$COMPOSER_REPOSITORY" magento/project-community-edition:"$MAGE_VERSION" /var/www/html --no-install --no-plugins
fi;
composer config --no-interaction allow-plugins.dealerdirect/phpcodesniffer-composer-installer true || true
composer config --no-interaction allow-plugins.laminas/laminas-dependency-plugin true || true
composer config --no-interaction allow-plugins.magento/* true || true
composer config --unset repo.0
composer config minimum-stability dev
composer config prefer-stable true

if [ -f "/current_extension/composer.json" ]; then
  echo "Composer - adding current extension"
  if [ "$COMPOSER_MODULE_SYMLINK" -eq "1" ]; then
    composer config "repositories.current_extension" "{\"type\": \"path\", \"canonical\":true, \"url\": \"/current_extension/\", \"options\": {\"symlink\":true}}"
  else
    composer config "repositories.current_extension" "{\"type\": \"path\", \"canonical\":true, \"url\": \"/current_extension/\", \"options\": {\"symlink\":false}}"
  fi
  PACKAGE_NAME=$(composer config name -d /current_extension/);
  composer require "$PACKAGE_NAME":'*' --no-interaction --no-update

  # prevent the module under test from being seen in packagist.org as well as local symlink
  composer config "repositories.packagist_org" "{\"type\": \"composer\", \"url\": \"https://packagist.org\", \"exclude\": [\"$PACKAGE_NAME\", \"magento/module-*\", \"magento/framework*\", \"magento/language*\", \"magento/magento2-base\", \"magento/theme*\"]}"
  composer config repositories.packagist false
  composer config repo.composerrepository "{\"type\": \"composer\", \"url\": \"$COMPOSER_REPOSITORY\", \"exclude\": [\"$PACKAGE_NAME\"]}"
else
  composer config repo.composerrepository composer "$COMPOSER_REPOSITORY"
fi

echo "Composer - requiring n98/magerun2"
composer require n98/magerun2-dist:"*" --dev --no-interaction --no-update

if [ ! "$COMPOSER_REQUIRE_EXTRA" = "0" ]; then
  echo "Composer - requiring $COMPOSER_REQUIRE_EXTRA"
  # shellcheck disable=SC2086
  composer require $COMPOSER_REQUIRE_EXTRA --no-interaction --no-update
fi

# Old versions of magento using composer 1 are struggling to detect the sodium package
if [[ "$MAGE_VERSION" == 2.4.2* ]]; then
  composer config platform.ext-sodium 2.0.22
fi

# fix test compatability with old monolog, as well as preventing newer dependencies being installed on old versions
# these newer dependencies implement ResetAfterRequestInterface which is not available in 2.4.4
if [[ "$MAGE_VERSION" == "2.4.4" ]]; then
  composer require --no-update monolog/monolog:"<2.7.0"
  composer require --no-update magento/module-inventory:"<1.2.5"
  composer require --no-update magento/module-re-captcha-webapi-graph-ql:"<1.0.3"
  composer require --no-update magento/module-inventory-reservations:"<1.2.3"
  composer require --no-update magento/module-inventory-import-export:"<1.2.5"
  composer require --no-update magento/module-inventory-configuration:"<1.2.4"
  composer require --no-update magento/module-re-captcha-webapi-graph-ql:"<1.0.3"
  composer require --no-update magento/module-re-captcha-version-3-invisible:"<2.0.4"
  composer require --no-update magento/module-re-captcha-ui:"<1.1.4"
fi

echo "Composer - installation"
cat composer.json
export COMPOSER_MEMORY_LIMIT=-1
if composer install --no-interaction; then
  echo "COMPOSER_INSTALL_TRY_1=PASS"
elif rm -rf vendor && composer install --no-interaction; then
  echo "COMPOSER_INSTALL_TRY_2=PASS"
else
  echo "COMPOSER_INSTALL_TRY_2=FAIL"
  false
fi

# Apply https://experienceleague.adobe.com/en/docs/commerce-operations/tools/quality-patches-tool/patches-available-in-qpt/v1-1-50/acsd-59280-fix-for-reflection-union-type-error
if [[ "$MAGE_VERSION" == 2.4.4* ]]; then
  curl https://raw.githubusercontent.com/magento/quality-patches/refs/heads/master/patches/os/ACSD-59280_2.4.4-p6.patch | patch -p1
fi

if [ ! "$COMPOSER_AFTER_INSTALL_COMMAND" = "0" ]; then
  echo "running after install command $COMPOSER_AFTER_INSTALL_COMMAND"
  eval "$COMPOSER_AFTER_INSTALL_COMMAND"
fi

if [ "$FULL_INSTALL" -eq "1" ]; then
  echo "FULL_INSTALL - Installing magento"

  echo "Configuring apache for $BASE_DOMAIN"
  sed \
  -e "s;%MAGENTO_PORT%;$MAGENTO_PORT;g" \
  -e "s;%DOCUMENT_ROOT%;/var/www/html;g" \
  /home/ampersand/assets/vhost.conf | tee /etc/apache2/sites-enabled/000-default.conf;

  sudo /usr/sbin/apachectl configtest

  echo "Starting apache"
  sudo /usr/sbin/apachectl restart

  echo "Starting php-fpm"
  /home/ampersand/.phpenv/versions/"$PHP_VERSION"/etc/init.d/php-fpm restart

  mysql -hdatabase -uroot -e "create database if not exists $MYSQL_DATABASE"

  # allow splitting for `$ELASTICSEARCH_OPTIONS`
  # shellcheck disable=SC2086
  php bin/magento setup:install \
      --admin-firstname=ampersand --admin-lastname=developer --admin-email=example@example.com \
      --admin-user=admin --admin-password=somepassword123 \
      --db-name="$MYSQL_DATABASE" --db-user=root --db-host=database\
      --backend-frontname=admin \
      --base-url="$BASE_URL" \
      --language=en_GB --currency=GBP --timezone=Europe/London \
      --use-rewrites=1 $ELASTICSEARCH_OPTIONS -vvv

  php bin/magento deploy:mode:set developer

  if [ ! "$TWOFACTOR_ENABLED" = "1" ]; then
    echo "Disabling 2fa modules"
    php bin/magento module:disable Magento_TwoFactorAuth || php bin/magento module:disable Magento_AdminAdobeImsTwoFactorAuth Magento_TwoFactorAuth || true
  fi

  vendor/bin/n98-magerun2 sys:info
  vendor/bin/n98-magerun2 config:store:get  web/unsecure/base_url
elif [ -f "/current_extension/composer.json" ]; then
  # We are not doing a full install, but have an extension, so enable all the modules so that di compile works
  php bin/magento module:enable --all
fi

if [ -f "/current_extension/composer.json" ]; then
  if [ "$MAGE_VERSION" = "0" ]; then
    # allows us to handle edge cases in latest version by version number
    MAGE_VERSION=$(php bin/magento --version | awk '{ print $3 }')
  fi

  echo "Configuring current extension for integration tests"
  mysql -hdatabase -uroot -e "create database if not exists magento_integration_tests"
  cp /home/ampersand/assets/install-config-mysql.php.dist dev/tests/integration/etc/install-config-mysql.php
  if [[ "$MAGE_VERSION" == 2.3* ]]; then
    cp /home/ampersand/assets/install-config-mysql-no-search.php.dist dev/tests/integration/etc/install-config-mysql.php
  fi
  if [[ "$MAGE_VERSION" == 2.4.8* ]]; then
    cp /home/ampersand/assets/install-config-mysql-es8.php.dist dev/tests/integration/etc/install-config-mysql.php
  fi
  php /home/ampersand/assets/prepare-phpunit-config.php /var/www/html "$(composer config name -d /current_extension/)" "$INTEGRATION_TESTS_PATH" "$UNIT_TESTS_PATH"
  php bin/magento setup:di:compile
  if [ ! "$FULL_INSTALL" -eq "1" ]; then
    echo "Removing app/etc/env.php"
    cat app/etc/env.php
    rm -f app/etc/env.php # https://github.com/magento/magento2/issues/37805#issuecomment-1658555063
  fi

  if [[ "$MAGE_VERSION" == 2.4.3 ]] || [[ "$MAGE_VERSION" == 2.4.4* ]] || [[ "$MAGE_VERSION" == 2.4.5* ]] || [[ "$MAGE_VERSION" == 2.4.7* ]] || [[ "$MAGE_VERSION" == 2.4.6-p2 ]]; then
    # Re-running the install process seems to fix this issue https://github.com/magento/magento2/issues/33802
    composer install --no-interaction
  fi
  if [[ "$MAGE_VERSION" == 2.4.0* ]]; then
    # Declaration of Dotdigitalgroup\Email\Test\Integration\Model\Sync\Review\ReviewTest::setUp() must be compatible
    # with PHPUnit\Framework\TestCase::setUp(): void
    rm -rf vendor/dotmailer/dotmailer-magento2-extension/Test/Integration/
  fi
fi

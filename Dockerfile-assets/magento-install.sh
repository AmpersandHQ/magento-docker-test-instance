#!/bin/bash
# shellcheck source=/dev/null
source /root/.bashrc
set -euo pipefail
cd /var/www/html
rm -f /var/www/html/*

COMPOSER_REPOSITORY=${COMPOSER_REPOSITORY:-https://repo-magento-mirror.fooman.co.nz/}
FULL_INSTALL=${FULL_INSTALL:-0}
BASE_DOMAIN="0.0.0.0:$MAGENTO_PORT"
BASE_URL="http://$BASE_DOMAIN"
MAGE_VERSION=${MAGE_VERSION:-0}
ELASTICSEARCH_OPTIONS=${ELASTICSEARCH_OPTIONS:-}
COMPOSER_REQUIRE_EXTRA=${COMPOSER_REQUIRE_EXTRA:-0}

echo "Setting the required version of PHP"
phpenv global "$PHP_VERSION"
php --version
ln -f -s /root/.phpenv/bin/"$COMPOSER_VERSION" /root/.phpenv/bin/composer && composer --version

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
composer config repo.composerrepository composer "$COMPOSER_REPOSITORY"
composer config minimum-stability dev
composer config prefer-stable true

echo "Composer - adding current extension"
if [ -f "/current_extension/composer.json" ]; then
  composer config "repositories.current_extension" "{\"type\": \"path\", \"canonical\":true, \"url\": \"/current_extension/\", \"options\": {\"symlink\":true}}"
  composer require "$(composer config name -d /current_extension/)":'*' --no-interaction --no-update
fi

echo "Composer - requiring n98/magerun2"
composer require n98/magerun2:"*" --dev --no-interaction --no-update

if [ ! "$COMPOSER_REQUIRE_EXTRA" = "0" ]; then
  echo "Composer - requiring $COMPOSER_REQUIRE_EXTRA"
  # shellcheck disable=SC2086
  composer require $COMPOSER_REQUIRE_EXTRA --no-interaction --no-update
fi

# Old versions of magento using composer 1 are struggling to detect the sodium package
if [[ "$MAGE_VERSION" == 2.4.2* ]]; then
  composer config platform.ext-sodium 2.0.22
fi;

echo "Composer - installation"
cat composer.json
export COMPOSER_MEMORY_LIMIT=-1
composer install

# TODO identify which versions wont work with integration tests for composer require monolog/monolog:"<2.7.0"
if [ -f "/current_extension/composer.json" ]; then
  echo "Configuring current extension for integration tests"
  mysql -hdatabase -uroot -e "create database if not exists magento_integration_tests"
  cp /ampersand/install-config-mysql.php.dist dev/tests/integration/etc/install-config-mysql.php
  if [[ "$MAGE_VERSION" == 2.3* ]]; then
    cp /ampersand/install-config-mysql-no-search.php.dist dev/tests/integration/etc/install-config-mysql.php
  fi
  php /ampersand/prepare-phpunit-config.php /var/www/html "$(composer config name -d /current_extension/)"
  php bin/magento module:enable --all && php bin/magento setup:di:compile

  if [[ "$MAGE_VERSION" == 2.4.3 ]] || [[ "$MAGE_VERSION" == 2.4.4* ]]; then
    # Seems to fix this issue https://github.com/magento/magento2/issues/33802#issuecomment-1112369298
    composer install --no-interaction
  fi
  if [[ "$MAGE_VERSION" == 2.4.0* ]]; then
    # Declaration of Dotdigitalgroup\Email\Test\Integration\Model\Sync\Review\ReviewTest::setUp() must be compatible
    # with PHPUnit\Framework\TestCase::setUp(): void
    rm vendor/dotmailer/dotmailer-magento2-extension/Test/Integration/Model/Sync/Review/ReviewTest.php
  fi
fi

if [ "$FULL_INSTALL" -eq "1" ]; then
  echo "FULL_INSTALL - Installing magento"

  echo "Configuring apache for $BASE_DOMAIN"
  sed \
  -e "s;%MAGENTO_PORT%;$MAGENTO_PORT;g" \
  -e "s;%DOCUMENT_ROOT%;/var/www/html;g" \
  /ampersand/vhost.conf | tee /etc/apache2/sites-enabled/000-default.conf;

  apachectl configtest

  echo "Starting apache"
  apachectl restart

  echo "Starting php-fpm"
  /root/.phpenv/versions/"$PHP_VERSION"/etc/init.d/php-fpm restart

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

  vendor/bin/n98-magerun2 sys:info
  vendor/bin/n98-magerun2 config:store:get  web/unsecure/base_url
fi

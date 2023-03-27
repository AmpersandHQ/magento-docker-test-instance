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

echo "Setting the required version of PHP"
phpenv global "$PHP_VERSION"
php --version
ln -f -s /root/.phpenv/bin/"$COMPOSER_VERSION" /root/.phpenv/bin/composer && composer --version

# Old versions of magento using composer 1 are struggling to detect the sodium package
COMPOSER_ARGS=""
if [[ "$MAGE_VERSION" == 2.4.2* ]]; then
  COMPOSER_ARGS='--ignore-platform-req=ext-sodium'
fi;

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

echo "Composer - adding extensions repositories"
COUNTER=0
for d in /extensions/* ; do
  if [ -d "$d" ]; then
    composer config "repositories.ext_$COUNTER" "{\"type\": \"path\", \"url\": \"$d\", \"options\": {\"symlink\":true}}"
    composer require "$(jq -r .name "$d/composer.json")":'*' --no-interaction --no-update
    # shellcheck disable=SC2004
    COUNTER=$(($COUNTER +1))
  fi
done

echo "Composer - requiring n98/magerun2"
composer require n98/magerun2:"*" --dev --no-interaction --no-update

# TODO identify which versions wont work with integration tests for composer require monolog/monolog:"<2.7.0"

echo "Composer - installation"
cat composer.json
export COMPOSER_MEMORY_LIMIT=-1
composer install "$COMPOSER_ARGS"

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

FROM ampco/magento-docker-test-instance:php-latest
SHELL ["/bin/bash", "-c"]

RUN sed -i 's/nobody/root/' /root/.phpenv/versions/8.2.2/etc/php-fpm.d/www.conf && sed -i 's/nobody/root/' /root/.phpenv/versions/8.1.6/etc/php-fpm.d/www.conf && sed -i 's/nobody/root/' /root/.phpenv/versions/7.4.29/etc/php-fpm.d/www.conf
RUN sed -i 's/php_opts="/php_opts="-R /' /root/.phpenv/versions/8.2.2/etc/init.d/php-fpm && sed -i 's/php_opts="/php_opts="-R /' /root/.phpenv/versions/8.1.6/etc/init.d/php-fpm && sed -i 's/php_opts="/php_opts="-R /' /root/.phpenv/versions/7.4.29/etc/init.d/php-fpm

# Disable xdebug for performance
RUN rm /root/.phpenv/versions/*/etc/conf.d/xdebug.ini

RUN a2enmod rewrite actions alias headers proxy proxy_fcgi proxy_http expires ssl

RUN source /root/.bashrc && wget https://raw.githubusercontent.com/composer/getcomposer.org/76a7060ccb93902cd7576b67264ad91c8a2700e2/web/installer -O - -q | php -- --quiet && mv composer.phar /root/.phpenv/bin/composer1 && /root/.phpenv/bin/composer1 self-update --1
RUN source /root/.bashrc && wget https://raw.githubusercontent.com/composer/getcomposer.org/76a7060ccb93902cd7576b67264ad91c8a2700e2/web/installer -O - -q | php -- --quiet && mv composer.phar /root/.phpenv/bin/composer2 && /root/.phpenv/bin/composer2 self-update --2
RUN source /root/.bashrc && wget https://raw.githubusercontent.com/composer/getcomposer.org/76a7060ccb93902cd7576b67264ad91c8a2700e2/web/installer -O - -q | php -- --quiet && mv composer.phar /root/.phpenv/bin/composer22 && /root/.phpenv/bin/composer22 self-update --2 && /root/.phpenv/bin/composer22 self-update --2.2

RUN mkdir -p /ampersand/ /extensions/
COPY Dockerfile-assets/* /ampersand/
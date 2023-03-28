FROM ampco/magento-docker-test-instance:php-latest
SHELL ["/bin/bash", "-c"]

RUN sed -i 's/nobody/root/' /root/.phpenv/versions/8.2.2/etc/php-fpm.d/www.conf && sed -i 's/nobody/root/' /root/.phpenv/versions/8.1.6/etc/php-fpm.d/www.conf && sed -i 's/nobody/root/' /root/.phpenv/versions/7.4.29/etc/php-fpm.d/www.conf
RUN sed -i 's/php_opts="/php_opts="-R /' /root/.phpenv/versions/8.2.2/etc/init.d/php-fpm && sed -i 's/php_opts="/php_opts="-R /' /root/.phpenv/versions/8.1.6/etc/init.d/php-fpm && sed -i 's/php_opts="/php_opts="-R /' /root/.phpenv/versions/7.4.29/etc/init.d/php-fpm

# Disable xdebug for performance
RUN rm /root/.phpenv/versions/*/etc/conf.d/xdebug.ini

RUN a2enmod rewrite actions alias headers proxy proxy_fcgi proxy_http expires ssl

RUN mkdir -p /ampersand/
COPY Dockerfile-assets/* /ampersand/
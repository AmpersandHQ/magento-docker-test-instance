FROM ampco/magento-docker-test-instance:php-latest
SHELL ["/bin/bash", "-c"]

USER root
RUN usermod -a -G www-data ampersand
RUN echo 'ampersand ALL=(ALL) NOPASSWD:/usr/sbin/apachectl configtest, /usr/sbin/apachectl restart, /usr/sbin/apachectl start, /usr/sbin/apachectl stop' | tee -a /etc/sudoers.d/ampersand
RUN apt-get install acl
RUN setfacl -m g:ampersand:rx /var/log/apache2 && setfacl -m g:ampersand:rx /var/log/apache2/*
RUN rm /var/www/html/index.html && chown -R ampersand:www-data /var/www/html && chown ampersand:www-data /etc/apache2/sites-enabled/000-default.conf

RUN sed -i 's/nobody/ampersand/' /home/ampersand/.phpenv/versions/8.2.2/etc/php-fpm.d/www.conf && sed -i 's/nobody/ampersand/' /home/ampersand/.phpenv/versions/8.1.6/etc/php-fpm.d/www.conf && sed -i 's/nobody/ampersand/' /home/ampersand/.phpenv/versions/7.4.29/etc/php-fpm.d/www.conf

# Disable xdebug for performance
RUN rm /home/ampersand/.phpenv/versions/*/etc/conf.d/xdebug.ini

RUN a2enmod rewrite actions alias headers proxy proxy_fcgi proxy_http expires ssl

WORKDIR /home/ampersand
RUN mkdir -p /home/ampersand/assets
COPY Dockerfile-assets/* /home/ampersand/assets
RUN chown -R ampersand:ampersand /home/ampersand/assets
USER ampersand

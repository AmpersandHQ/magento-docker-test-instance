FROM ampco/magento-docker-test-instance:php-2023-12-07
SHELL ["/bin/bash", "-c"]

USER root
RUN usermod -a -G www-data ampersand
RUN echo 'ampersand ALL=(ALL) NOPASSWD:/usr/sbin/apachectl configtest, /usr/sbin/apachectl restart, /usr/sbin/apachectl start, /usr/sbin/apachectl stop' | tee -a /etc/sudoers.d/ampersand
RUN apt-get install acl
RUN setfacl -m g:ampersand:rx /var/log/apache2 && setfacl -m g:ampersand:rx /var/log/apache2/*
RUN rm /var/www/html/index.html && chown -R ampersand:www-data /var/www/html && chown ampersand:www-data /etc/apache2/sites-enabled/000-default.conf

RUN sed -i 's/nobody/ampersand/' /home/ampersand/.phpenv/versions/8.3.0/etc/php-fpm.d/www.conf && sed -i 's/nobody/ampersand/' /home/ampersand/.phpenv/versions/8.2.2/etc/php-fpm.d/www.conf && sed -i 's/nobody/ampersand/' /home/ampersand/.phpenv/versions/8.1.6/etc/php-fpm.d/www.conf && sed -i 's/nobody/ampersand/' /home/ampersand/.phpenv/versions/7.4.29/etc/php-fpm.d/www.conf

RUN a2enmod rewrite actions alias headers proxy proxy_fcgi proxy_http expires ssl

WORKDIR /home/ampersand
USER ampersand

# Disable xdebug for performance
RUN for ver in $(phpenv versions --bare); do printf "\nxdebug.mode=debug\nxdebug.client_host=docker.for.mac.localhost\nxdebug.client_port=9010\nxdebug.idekey=PHPSTORM\n" >> /home/ampersand/.phpenv/versions/$ver/etc/conf.d/xdebug.ini ; done
RUN for ver in $(phpenv versions --bare); do mkdir /home/ampersand/.phpenv/versions/$ver/etc/conf.d_disabled/; done
RUN for ver in $(phpenv versions --bare); do mv /home/ampersand/.phpenv/versions/$ver/etc/conf.d/xdebug.ini /home/ampersand/.phpenv/versions/$ver/etc/conf.d_disabled/; done

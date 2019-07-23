FROM php:7.1.11-apache-jessie
RUN set -e; \
  BUILD_PACKAGES="libzip-dev libssh2-1-dev unixodbc-dev"; \
  a2enmod headers proxy proxy_http ssl rewrite; \
  apt-get update; \
  apt-get install -y $BUILD_PACKAGES; \
  set +e; \
  docker-php-ext-install odbc; \
  set -e; \
  cd /usr/src/php/ext/odbc; \
  phpize; \
  sed -ri 's@^ *test +"\$PHP_.*" *= *"no" *&& *PHP_.*=yes *$@#&@g' configure; \
  ./configure --with-unixODBC=shared,/usr; \
  cd /root; \
  yes | pecl install ssh2-1.1.2; \
  docker-php-ext-configure pdo_odbc --with-pdo-odbc=unixODBC,/usr; \ 
  docker-php-ext-install pdo_mysql mysqli zip pdo_odbc odbc; \
  docker-php-ext-enable ssh2; \
  apt-get remove --purge -y $BUILD_PACKAGES && rm -rf /var/lib/apt/lists/*; \
  apt-get clean;

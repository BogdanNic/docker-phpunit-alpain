FROM php:7.3-fpm-alpine

MAINTAINER Dmitry Boyko <dmitry@thebodva.com>

RUN apk add --update bash && rm -rf /var/cache/apk/*

RUN php -r "copy('https://getcomposer.org/installer', '/tmp/composer-setup.php');"
RUN php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer && \
    rm -rf /tmp/composer-setup.php

RUN php -r "copy('https://phar.phpunit.de/phpunit.phar','/tmp/phpunit.phar');"
RUN chmod +x /tmp/phpunit.phar
RUN mv /tmp/phpunit.phar /usr/local/bin/phpunit

RUN apk add --no-cache git unzip  \
    && rm -rf /tmp/* /var/cache/apk/*

RUN apk add --no-cache \
        freetype-dev \
        libjpeg-turbo-dev \
        libxml2-dev \
        autoconf \
        g++ \
        imagemagick-dev \
        libtool \
        make \
        libmcrypt-dev \
        libpng-dev \
        sqlite-dev \
        curl-dev \
        pcre-dev \
    && docker-php-ext-install -j11 iconv mcrypt pdo_mysql pcntl pdo_sqlite zip curl bcmath mbstring mysqli opcache soap\
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j1 gd \
    && docker-php-ext-enable iconv mcrypt gd pdo_mysql pcntl pdo_sqlite zip curl bcmath mbstring mysqli  soap\
    && rm -rf /tmp/* /var/cache/apk/*

RUN pecl install imagick && docker-php-ext-enable imagick

RUN docker-php-ext-install exif \
    && docker-php-ext-enable exif

EXPOSE 9000

CMD ["php-fpm"]
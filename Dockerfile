FROM php:8.3-fpm

ARG user=laravel
ARG uid=1001

RUN apt-get update
RUN apt-get upgrade -y --no-install-recommends apt-utils

RUN apt-get update && apt-get install -y git curl libpng-dev libonig-dev libxml2-dev zip snmpd
RUN apt-get install -y zlib1g-dev libzip-dev unzip libpq-dev

RUN docker-php-ext-install mysqli pdo pdo_mysql pdo_pgsql pgsql session xml soap snmp

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer 

RUN docker-php-ext-install zip iconv simplexml pcntl gd fileinfo

RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

RUN pecl install -o -f redis \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis

WORKDIR /var/www

COPY docker/php/custom.ini /usr/local/etc/php/conf.d/custom.ini

USER $user
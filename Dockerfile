FROM debian:wheezy
MAINTAINER Patrik Nilsson <asavartzeth@gmail.com>

ENV PHP_VERSION 5.4.36-0+deb7u3
ENV PHP_IMAGICK_VERSION 3.1.0~rc1-1+b2

# All our dependencies, in alphabetical order (to ease maintenance)
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
	php5-common=$PHP_VERSION \
	php5-curl=$PHP_VERSION \
	php5-fpm=$PHP_VERSION \
	php5-gd=$PHP_VERSION \
	php5-intl=$PHP_VERSION \
	php5-imagick=$PHP_IMAGICK_VERSION \
	php5-ldap=$PHP_VERSION \
	php5-mcrypt=$PHP_VERSION \
	php5-mysql=$PHP_VERSION \
	php5-pgsql=$PHP_VERSION \
	php5-sqlite=$PHP_VERSION && \
    rm -rf /var/lib/apt/lists/*

# Find & update config files
RUN find /etc/php5/fpm -type f -exec sed -ri ' \
    s|;*\s*(error_log\s*=\s*).*|\1/proc/self/fd/2|; \
    s|;*\s*(daemonize\s*=\s*).*|\1no|; \
' '{}' ';'

WORKDIR /etc/php5/fpm

COPY ./docker-entrypoint.sh /entrypoint.sh
RUN chmod 744 /entrypoint.sh

EXPOSE 9000

# TODO USER www-data

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/php5-fpm"]

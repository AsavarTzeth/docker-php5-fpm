FROM debian:wheezy
MAINTAINER Patrik Nilsson <asavartzeth@gmail.com>

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

# Common environment variables
ENV CONF_DIR_PHP5_FPM /etc/php5/fpm

# All our dependencies, in alphabetical order (to ease maintenance)
RUN apt-get update && apt-get install -y --no-install-recommends \
        php5-curl \
        php5-fpm \
        php5-gd \
        php5-intl \
        php5-imagick \
        php5-ldap \
        php5-mcrypt \
        php5-mhash \
        php5-mysql \
        php5-pgsql \
        php5-sqlite

# Find config files and edit
RUN find "$CONF_DIR_PHP5_FPM" -type f -exec sed -ri ' \
    s|(error_log\s+=).*|\1 /proc/self/fd/2|g; \
    s|\S*(daemonize\s+=).*|\1 no|g; \
' '{}' ';'

WORKDIR /etc/php5/fpm

ADD ./docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 9000
CMD ["php5-fpm"]

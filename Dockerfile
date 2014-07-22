FROM debian:wheezy
MAINTAINER Patrik Nilsson <asavartzeth@gmail.com>

# All our dependencies, in alphabetical order (to ease maintenance)
# php5-mhash now seem to be provided by php5-common
RUN apt-get update && apt-get install -y --no-install-recommends \
        php5 \
        php5-cgi \
        php5-cli \
        php5-curl \
        php5-gd \
        php5-fpm \
        php5-mcrypt \
        php5-mhash \
        php5-mysql

ENV CONF_DIR /etc/php5/fpm

# Find all files in $CONF_DIR and do edits listed below
RUN find "$CONF_DIR" -type f -exec sed -ri ' \
    s|\(error_log[\s+=]).*|\1 /proc/self/fd/2|g; \
    s|\S*(daemonize\s+=).*|\1 no|g; \
' '{}' ';'

WORKDIR /etc/php5/fpm

ADD docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 9000
CMD ["php5-fpm"]
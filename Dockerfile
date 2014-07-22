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

# Forward logs
RUN sed -ri "s;(\S*error_log\s+=).*;\1 /proc/self/fd/2;g" /etc/php5/fpm/php-fpm.conf \
    && sed -ri "s;\S*(daemonize\s+=).*;\1 no;g" /etc/php5/fpm/php-fpm.conf

WORKDIR /etc/php5/fpm

ADD docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 9000
CMD ["php5-fpm"]
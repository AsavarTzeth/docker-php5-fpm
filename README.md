#How to use this image:#

    docker run --name some-php5-fpm --link some-nginx:nginx -d asavartzeth/php5-fpm

The following environment variables are also honored for configuring your PHP-FPM instance:

- -e `PHP_FPM_MEMORY_LIMIT=...` (defaults to “128M”)
- -e `PHP_FPM_LOG_LEVEL=...` (defaults to notice)  
Possible Values: alert, error, warning, notice, debug
- -e `PHP_FPM_LISTEN=...` (defaults to 127.0.0.1:9000)  
Alternative value: /var/run/php5-fpm.sock

To use php5-fpm with unix sockets you may run the container like this:

    docker run --name some-php5-fpm --volumes-from some-nginx -d asavartzeth/php5-fpm

For the second method to work you must make sure you first run your nginx instance like this:

    docker run --name some-nginx -v /var/run -d nginx

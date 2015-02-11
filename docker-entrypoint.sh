#!/bin/bash
set -e

: ${PHP5_FPM_MEMORY_LIMIT:=128M}
: ${PHP5_FPM_LOG_LEVEL:=notice}
: ${PHP5_FPM_LISTEN:=127.0.0.1:9000}

# Function used to update the service environment configuration
function set_config() {
	key="$1"
	value="$2"
	# Edit php.ini, php-fpm.conf & pool.d/www.conf
	sed -ri "s|;*\s*($key\s*=\s*).*|\1$value|" $config_file
}

# Run configuration function for each config file
config_file="/etc/php5/fpm/php.ini"
set_config 'memory_limit' "$PHP5_FPM_MEMORY_LIMIT"

config_file="/etc/php5/fpm/php-fpm.conf"
set_config 'log_level' "$PHP5_FPM_LOG_LEVEL"

config_file="/etc/php5/fpm/pool.d/www.conf"
set_config 'listen' "$PHP5_FPM_LISTEN"

exec "$@"

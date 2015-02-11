#!/bin/bash
set -e

: ${PHP5_FPM_MEMORY_LIMIT:=128M}
: ${PHP5_FPM_LOG_LEVEL:=notice}
: ${PHP5_FPM_LISTEN:=127.0.0.1:9000}

# Function that updates the configuration of the service environment
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

# Function to update the fpm configuration to make the service environment variables available
function setEnvironmentVariable() {
	# Add variable
	echo "env[$1] = $2" >> /etc/php5/fpm/pool.d/www.conf
}

# Grep for variables that look like docker set them (_PORT_)
for _curVar in `env | grep _PORT_ | awk -F = '{print $1}'`;do
	# awk has split them by the equals sign
	# Pass the name and value to our function
	setEnvironmentVariable ${_curVar} ${!_curVar}
done

exec "$@"

#!/bin/bash
set -e

# Always declare configuration directory
# This way docker-entrypoint.sh is indipendent from Dockerfile and portable
CONF_DIR=/etc/php5/fpm

# Set default values for configurations
: ${PHP_FPM_MEMORY_LIMIT:=128M}
: ${PHP_FPM_LOG_LEVEL:=notice}
: ${PHP_FPM_LISTEN_TYPE:=127.0.0.1:9000}

set_config() {
    key="$1"
    value="$2"
    for i in "$CONF_DIR"/*; do
        sed -ri "s;\S*($key\s+=).*;\1 $value;g" $i
    done
}

# Apply default or user specified options to config files
set_config 'memory_limit' "$PHP_FPM_MEMORY_LIMIT"
set_config 'log_level' "$PHP_FPM_LOG_LEVEL"
set_config 'listen' "$PHP_FPM_LISTEN_TYPE"

exec "$@"
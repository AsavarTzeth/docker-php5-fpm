#!/bin/bash
set -e

# Set default values for configurations
: ${PHP_FPM_MEMORY_LIMIT:=128M}
: ${PHP_FPM_LOG_LEVEL:=notice}
: ${PHP_FPM_LISTEN:=127.0.0.1:9000}

# Common config edit function
set_config() {
    key="$1"
    value="$2"
    # Do a loop so sed can scale with number of files/options
    for i in $(find $CONF_DIR -type f); do
        sed -ri "s|\S*($key\s+=).*|\1 $value|g" $i
    done
}

# Apply default or user specified options to config files
set_config 'memory_limit' "$PHP_FPM_MEMORY_LIMIT"
set_config 'log_level' "$PHP_FPM_LOG_LEVEL"
set_config 'listen' "$PHP_FPM_LISTEN"

exec "$@"
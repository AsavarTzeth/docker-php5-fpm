#!/bin/bash
set -e

: ${PHP5_FPM_MEMORY_LIMIT:=128M}
: ${PHP5_FPM_LOG_LEVEL:=notice}
: ${PHP5_FPM_LISTEN:=127.0.0.1:9000}

# Common config edit function
set_config() {
    key="$1"
    value="$2"
    # Do a loop so sed can scale with number of files/options
    for i in $(find $CONF_DIR_PHP5_FPM -type f); do
        sed -ri "s|\S*($key\s+=).*|\1 $value|g" $i
    done
}

# Apply default or user specified options to config files
set_config 'memory_limit' "$PHP5_FPM_MEMORY_LIMIT"
set_config 'log_level' "$PHP5_FPM_LOG_LEVEL"
set_config 'listen' "$PHP5_FPM_LISTEN"

exec "$@"
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

# Function to update the fpm configuration to make the service environment variables available
function setEnvironmentVariable() {

    if [ -z "$2" ]; then
            echo "Environment variable '$1' not set."
            return
    fi

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

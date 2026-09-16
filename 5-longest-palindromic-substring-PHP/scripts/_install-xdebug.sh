#!/bin/bash

# Detect the directory PHP scans for additional ini files
PHP_CONF_DIR=$(php -r 'echo PHP_CONFIG_FILE_SCAN_DIR;')
if [ -z "$PHP_CONF_DIR" ]; then
    echo "Unable to detect PHP configuration directory."
    exit 1
fi
mkdir -p "$PHP_CONF_DIR"

# Check if Xdebug is installed
if ! php -m | grep -qi xdebug; then
    echo "Xdebug is not installed in leetup container. Installing..."

    apk add --no-cache php-pecl-xdebug

    # The package ships the extension, but does not necessarily enable it
    if ! php -m | grep -qi xdebug; then
        echo "zend_extension=xdebug.so" > "$PHP_CONF_DIR/00_xdebug.ini"
    fi

    # Verify installation
    if ! php -m | grep -qi xdebug; then
        echo "Xdebug installation failed."
        exit 1
    fi

    echo "Xdebug installed successfully: $(php -r 'echo phpversion("xdebug"), PHP_EOL;')"
fi

# Write Xdebug configuration. Step debugging is off by default so that check.sh
# keeps running at full speed, debug.sh turns it on via XDEBUG_MODE
cat > "$PHP_CONF_DIR/zz_xdebug.ini" <<'XDEBUG_EOF'
xdebug.mode=off
xdebug.start_with_request=yes
xdebug.client_host=host.docker.internal
xdebug.client_port=9003
xdebug.idekey=leetup
XDEBUG_EOF

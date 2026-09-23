#!/bin/bash

# Container entrypoint, run on container start when the host-specific environment
# is known. Everything written here depends on values the host supplies, so it
# cannot be baked into the image at build time

# Write delve configuration, mapping container paths to host ones, so that the
# IDE resolves sources during a debug session
if [ -n "$HOST_PROJECT_PATH" ]; then
    mkdir -p ~/.config/dlv
    cat > ~/.config/dlv/config.yml <<DELVE_EOF
substitute-path:
  - {from: /workspace, to: $HOST_PROJECT_PATH}
DELVE_EOF
fi

# Write Xdebug configuration, pointing it at the IDE listener on the host. Step
# debugging is off by default so that check.sh keeps running at full speed,
# debug.sh turns it on via XDEBUG_MODE
PHP_CONF_DIR=$(php -r 'echo PHP_CONFIG_FILE_SCAN_DIR;')
mkdir -p "$PHP_CONF_DIR"
# The value of mode is quoted because PHP's ini parser otherwise reads a bare off
# as a boolean and hands Xdebug an empty string
printf '%s\n' \
    'xdebug.mode="off"' \
    'xdebug.start_with_request=yes' \
    "xdebug.client_host=${XDEBUG_CLIENT_HOST:-host.docker.internal}" \
    "xdebug.client_port=${XDEBUG_CLIENT_PORT:-9003}" \
    > "$PHP_CONF_DIR/zz_xdebug.ini"

# Run the container command
exec "$@"

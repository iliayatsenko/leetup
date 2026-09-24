FROM alpine:3

# Install required tools and the Go toolchain
RUN apk add --no-cache bash curl jq pandoc docker go

# Install delve, used to debug Go solutions
RUN GOBIN=/usr/local/bin go install github.com/go-delve/delve/cmd/dlv@latest

# Install PHP with the extensions PHPUnit needs, Composer and Xdebug
RUN apk add --no-cache \
    php php-cli php-mbstring php-xml php-dom php-ctype php-tokenizer \
    php-xmlwriter php-phar php-json php-iconv php-openssl \
    composer php-pecl-xdebug

# Enable Xdebug if the package did not. Its settings are host-specific, so the
# entrypoint writes them on container start instead
RUN set -eu; \
    PHP_CONF_DIR=$(php -r 'echo PHP_CONFIG_FILE_SCAN_DIR;'); \
    mkdir -p "$PHP_CONF_DIR"; \
    if ! php -m | grep -qi xdebug; then \
        echo "zend_extension=xdebug.so" > "$PHP_CONF_DIR/00_xdebug.ini"; \
    fi; \
    php -m | grep -qi xdebug

# Create a command per workspace script, e.g. check runs scripts/check.sh. The
# dependency one is installdeps rather than install so that it does not shadow
# the busybox install(1) the toolchains use
RUN for cmd in setup installdeps check debug hints review; do \
        printf '#!/bin/bash\ncd /workspace && ./scripts/%s.sh "$@"\n' "$cmd" > "/usr/local/bin/$cmd"; \
        chmod +x "/usr/local/bin/$cmd"; \
    done

# Set working directory
WORKDIR /workspace

# Write delve and Xdebug configuration, then keep container running. The
# entrypoint is read from the mounted workspace, like the scripts the commands
# above call
ENTRYPOINT ["/bin/bash", "/workspace/entrypoint.sh"]
CMD ["tail", "-f", "/dev/null"]

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

# Enable Xdebug. Its settings are host-specific, so the
# entrypoint writes them on container start instead
RUN set -eu; \
    PHP_CONF_DIR=$(php -r 'echo PHP_CONFIG_FILE_SCAN_DIR;'); \
    mkdir -p "$PHP_CONF_DIR"; \
    if ! php -m | grep -qi xdebug; then \
        echo "zend_extension=xdebug.so" > "$PHP_CONF_DIR/00_xdebug.ini"; \
    fi; \
    php -m | grep -qi xdebug

# Create an executable shortcut for each script
RUN for cmd in setup installdeps check debug hints review; do \
        printf '#!/bin/bash\ncd /workspace && ./scripts/%s.sh "$@"\n' "$cmd" > "/usr/local/bin/$cmd"; \
        chmod +x "/usr/local/bin/$cmd"; \
    done

# Set working directory
WORKDIR /workspace

# Do after-start preparations
ENTRYPOINT ["/bin/bash", "/workspace/entrypoint.sh"]

# Keep container running.
CMD ["tail", "-f", "/dev/null"]

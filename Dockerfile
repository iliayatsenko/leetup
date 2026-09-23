FROM alpine:3

# Install required tools
RUN apk update && apk add --no-cache bash curl jq pandoc docker

# Install Go toolchain
RUN apk add --no-cache go

# Install delve, used to debug Go solutions
RUN GOBIN=/usr/local/bin go install github.com/go-delve/delve/cmd/dlv@latest

# Keep the Go module cache in the bind-mounted workspace, next to deps/php/vendor,
# so it survives container recreation. Set after the delve install above, which has
# to resolve its modules at build time, before the workspace is mounted
ENV GOMODCACHE=/workspace/deps/go/pkg/mod

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

# Create setup wrapper in container
RUN echo '#!/bin/bash' > /usr/local/bin/setup && \
    echo 'cd /workspace && ./scripts/setup.sh "$@"' >> /usr/local/bin/setup && \
    chmod +x /usr/local/bin/setup

# Create dependency installation wrapper in container. Named installdeps rather
# than install so that it does not shadow the busybox install(1) the toolchains use
RUN echo '#!/bin/bash' > /usr/local/bin/installdeps && \
    echo 'cd /workspace && ./scripts/installdeps.sh "$@"' >> /usr/local/bin/installdeps && \
    chmod +x /usr/local/bin/installdeps

# Create testing wrapper in container
RUN echo '#!/bin/bash' > /usr/local/bin/check && \
    echo 'cd /workspace && ./scripts/check.sh "$@"' >> /usr/local/bin/check && \
    chmod +x /usr/local/bin/check

# Create debugging wrapper in container
RUN echo '#!/bin/bash' > /usr/local/bin/debug && \
    echo 'cd /workspace && ./scripts/debug.sh "$@"' >> /usr/local/bin/debug && \
    chmod +x /usr/local/bin/debug

# Create hints generation wrapper in container
RUN echo '#!/bin/bash' > /usr/local/bin/hints && \
    echo 'cd /workspace && ./scripts/hints.sh "$@"' >> /usr/local/bin/hints && \
    chmod +x /usr/local/bin/hints

# Create review wrapper in container
RUN echo '#!/bin/bash' > /usr/local/bin/review && \
    echo 'cd /workspace && ./scripts/review.sh "$@"' >> /usr/local/bin/review && \
    chmod +x /usr/local/bin/review

# Set working directory
WORKDIR /workspace

# Write delve configuration, then keep container running. The entrypoint is read
# from the mounted workspace, like the scripts the wrappers above call
ENTRYPOINT ["/bin/bash", "/workspace/entrypoint.sh"]
CMD ["tail", "-f", "/dev/null"]

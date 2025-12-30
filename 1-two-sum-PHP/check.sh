#!/bin/bash

# Check if PHP is installed
if ! command -v php &> /dev/null; then
    echo "PHP is not installed in leetup container. Installing..."

    apk update
    apk add --no-cache php php-cli php-mbstring php-xml php-dom php-ctype php-tokenizer php-xmlwriter php-phar php-json php-iconv php-openssl

    # Verify installation
    if ! command -v php &> /dev/null; then
        echo "PHP installation failed."
        exit 1
    fi

    echo "PHP installed successfully: $(php --version)"
fi

# Check if Composer is installed
if ! command -v composer &> /dev/null; then
    echo "Composer is not installed. Installing..."

    apk add --no-cache composer

    # Verify installation
    if ! command -v composer &> /dev/null; then
        echo "Composer installation failed."
        exit 1
    fi

    echo "Composer installed successfully: $(composer --version)"
fi

# Install dependencies if vendor directory doesn't exist
if [ ! -d vendor ]; then
    composer install --no-interaction
fi

# Run PHPUnit tests
if [ -d tests ]; then
    ./vendor/bin/phpunit tests
else
    echo "No tests directory found. Please create tests for your solution."
fi

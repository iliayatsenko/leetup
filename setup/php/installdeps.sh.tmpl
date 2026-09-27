#!/bin/bash

# Entry point for installing the dependencies declared by the solution

# Fail on errors and unset variables, and print each command before running it
set -eux

# Run from the problem directory, not from the scripts one
cd "$(dirname "$0")/.."

DEPS_DIR=../deps/php

# Install the test tooling shared by every PHP problem, once.
if [ ! -x "$DEPS_DIR/vendor/bin/phpunit" ]; then
    composer install --working-dir="$DEPS_DIR" --no-interaction
fi

# Resolve what this problem requires into its own vendor directory. Nothing is
# shared, so installing one problem can never uninstall another one's packages.
# This is composer update rather than install because the require section is
# edited by hand, and install refuses to run against a composer.lock that no
# longer matches it
composer update --no-interaction

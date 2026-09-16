#!/bin/bash

# Run from the problem directory, not from the scripts one
cd "$(dirname "$0")/.." || exit 1

# Install dependencies if vendor directory doesn't exist
if [ ! -d ../deps/php/vendor ]; then
    composer install --no-interaction
fi

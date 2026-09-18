#!/bin/bash

# Entry point for installing the dependencies declared by the solution
set -e

# Run from the problem directory, not from the scripts one
cd "$(dirname "$0")/.."

# Resolve what composer.json requires into deps/php/vendor. This is composer update
# rather than composer install because the require section is edited by hand here,
# and install refuses to run against a composer.lock that no longer matches it
composer update --no-interaction

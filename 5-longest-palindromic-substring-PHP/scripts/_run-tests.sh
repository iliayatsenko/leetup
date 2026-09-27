#!/bin/bash

PHPUNIT=../deps/php/vendor/bin/phpunit

# Run PHPUnit tests. PHPUnit is shared tooling installed under deps/php, so its own
# autoloader knows nothing about what this problem requires; the vendor/autoload.php
# that installdeps writes here is what resolves those
if [ ! -f solution_test.php ]; then
    echo "No solution_test.php found. Please create tests for your solution."
    exit 1
elif [ ! -x "$PHPUNIT" ]; then
    echo "No test tooling found. Run 'installdeps <problem-directory>' first."
    exit 1
elif [ -f vendor/autoload.php ]; then
    "$PHPUNIT" --bootstrap vendor/autoload.php solution_test.php
else
    "$PHPUNIT" solution_test.php
fi

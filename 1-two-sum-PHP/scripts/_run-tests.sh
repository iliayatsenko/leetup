#!/bin/bash

# Run from the problem directory, not from the scripts one
cd "$(dirname "$0")/.." || exit 1

# Run PHPUnit tests
if [ -d tests ]; then
    phpunit tests
else
    echo "No tests directory found. Please create tests for your solution."
fi

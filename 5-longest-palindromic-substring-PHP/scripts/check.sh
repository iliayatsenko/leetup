#!/bin/bash

# Entry point for checking the solution
set -e

# Run from the problem directory, not from the scripts one
cd "$(dirname "$0")/.."

./scripts/_install-php.sh
./scripts/_install-deps.sh
./scripts/_run-tests.sh

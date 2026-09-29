#!/bin/bash

# Entry point for checking the solution

# Fail on errors and unset variables, and print each command before running it
set -eux

# Run from the problem directory, not from the scripts one
cd "$(dirname "$0")/.."

./scripts/_run-tests.sh

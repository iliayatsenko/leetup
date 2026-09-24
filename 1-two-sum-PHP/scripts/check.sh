#!/bin/bash

# Entry point for checking the solution
set -e

# Run from the problem directory, not from the scripts one
cd "$(dirname "$0")/.."

./scripts/_run-tests.sh

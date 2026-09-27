#!/bin/bash

# Entry point for installing the dependencies declared by the solution
# Fail on errors and unset variables, and print each command before running it
set -eux

# Run from the problem directory, not from the scripts one
cd "$(dirname "$0")/.."

# Sync go.mod and go.sum with what the solution and its test import, downloading
# the modules into the Go module cache
go mod tidy

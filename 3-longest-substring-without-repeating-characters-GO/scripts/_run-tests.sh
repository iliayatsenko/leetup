#!/bin/bash

# Run from the problem directory, not from the scripts one
cd "$(dirname "$0")/.." || exit 1

# Run Go tests with verbose output
go test -v ./...

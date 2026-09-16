#!/bin/bash

# Run from the problem directory, not from the scripts one
cd "$(dirname "$0")/.." || exit 1

# Run headless delve session with go tests
~/go/bin/dlv test . --listen=:40000 --headless=true --api-version=2

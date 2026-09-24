#!/bin/bash

# Run from the problem directory, not from the scripts one
cd "$(dirname "$0")/.." || exit 1

# Run headless delve session with go tests. The port is the container-side one,
# fixed; the host port it is published on is DELVE_PORT in .env
dlv test . --listen=:40000 --headless=true --api-version=2

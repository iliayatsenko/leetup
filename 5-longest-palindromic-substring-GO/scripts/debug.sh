#!/bin/bash

# Entry point for debugging the solution. See how to connect to IDE:
#  - GoLand - https://www.jetbrains.com/help/go/attach-to-running-go-processes-with-debugger.html#step-2-create-the-go-remote-run-debug-configuration
#  - VSCode - https://github.com/golang/vscode-go/wiki/debugging#connect-to-headless-delve-with-target-specified-at-server-start-up
set -e

# Run from the problem directory, not from the scripts one
cd "$(dirname "$0")/.."

./scripts/_run-debug.sh

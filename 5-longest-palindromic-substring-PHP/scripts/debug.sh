#!/bin/bash

# Entry point for debugging the solution. Xdebug connects out to the IDE listener
# on port 9003, map /workspace to /Users/ilyayatsenko/my/leetup in the IDE:
#  - PhpStorm - https://www.jetbrains.com/help/phpstorm/zero-configuration-debugging.html
#  - VSCode - https://github.com/xdebug/vscode-php-debug#remote-host-debugging
set -e

# Run from the problem directory, not from the scripts one
cd "$(dirname "$0")/.."

XDEBUG_MODE=debug PHP_IDE_CONFIG="serverName=leetup" ./scripts/_run-tests.sh

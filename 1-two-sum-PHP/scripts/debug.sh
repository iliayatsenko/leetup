#!/bin/bash

# Entry point for debugging the solution. Xdebug connects out to the IDE listener
# on port 9003, map /workspace to /Users/ilyayatsenko/my/leetup in the IDE:
#  - PhpStorm - https://www.jetbrains.com/help/phpstorm/zero-configuration-debugging.html
#  - VSCode - https://github.com/xdebug/vscode-php-debug#remote-host-debugging
set -e

# Run from the problem directory, not from the scripts one
cd "$(dirname "$0")/.."

./scripts/_install-php.sh
./scripts/_install-xdebug.sh
./scripts/_install-deps.sh
XDEBUG_MODE=debug ./scripts/_run-tests.sh

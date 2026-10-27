#!/bin/bash

# Entry point for debugging the solution. Attach the IDE to localhost:NODE_INSPECT_PORT
# and map /workspace to the project directory on the host:
#  - WebStorm - https://www.jetbrains.com/help/webstorm/running-and-debugging-node-js.html#ws_node_debug_remote_chrome
#  - VSCode - https://code.visualstudio.com/docs/nodejs/nodejs-debugging#_remote-debugging (set "remoteRoot": "/workspace")

# Fail on errors and unset variables, and print each command before running it
set -eux

# Run from the problem directory, not from the scripts one
cd "$(dirname "$0")/.."

# Run the test file directly rather than through --test, so the tests run in this
# process and the inspector sees them. --inspect-brk pauses on the first line until
# the IDE attaches. The port is the container-side one, fixed; the host port it is
# published on is NODE_INSPECT_PORT in .env
node --inspect-brk=0.0.0.0:9229 solution_test.js

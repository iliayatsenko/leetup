#!/bin/sh

# Runs an opencode command, if the opencode config is in place.
# Runs inside the opencode container. Usage: run-command-if-configured.sh <command> <problem-directory>

if [ ! -f /workspace/opencode.jsonc ]; then
    echo "⚠️  opencode.jsonc not found, skipping the AI agent."
    echo "   Create it with: cp opencode.jsonc.dist opencode.jsonc, then fill in the provider and API key."
    exit 1
fi

opencode run --command "$@"

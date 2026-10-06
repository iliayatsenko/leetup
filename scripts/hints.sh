#!/bin/bash

# Check if problem directory is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <problem-directory>"
    exit 1
fi

PROBLEM_DIR=$1

# Check if problem directory exists
if [ ! -d "$PROBLEM_DIR" ]; then
    echo "Error: Problem directory '$PROBLEM_DIR' not found"
    exit 1
fi

# The credentials are passed to opencode from .env on each call, so check them there
set -a; . /workspace/.env; set +a
MISSING_VARS=()
for var in OPENCODE_PROVIDER_ID OPENCODE_MODEL_ID OPENCODE_API_KEY; do
    if [ -z "${!var}" ]; then
        MISSING_VARS+=("$var")
    fi
done

if [ ${#MISSING_VARS[@]} -gt 0 ]; then
    echo "⚠️  Skipping hints generation, not set in .env: ${MISSING_VARS[*]}"
    exit 0
fi

echo "⚡ Generating hints for problem $PROBLEM_DIR..."
docker exec --env-file /workspace/.env opencode opencode run --command leetup-hints "$PROBLEM_DIR"

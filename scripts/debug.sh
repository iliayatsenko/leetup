#!/bin/bash

# Check if problem directory is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <problem-directory>"
    exit 1
fi

PROBLEM_DIR=$1

# SQL problems are run from a DB client, they have no scripts
if [[ "${PROBLEM_DIR%/}" == *-SQL ]]; then
    echo "Error: 'debug' is not supported for SQL problems"
    exit 1
fi

# Check if debug script exists
if [ ! -f "$PROBLEM_DIR/scripts/debug.sh" ]; then
    echo "Error: Debug script not found for problem directory '$PROBLEM_DIR'"
    exit 1
fi

# Run debug session
echo "⚡ Running debug session for solution of problem $PROBLEM_DIR..."
"$PROBLEM_DIR/scripts/debug.sh"

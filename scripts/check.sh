#!/bin/bash

# Check if problem directory is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <problem-directory>"
    exit 1
fi

PROBLEM_DIR=$1

# SQL problems are run from a DB client, they have no scripts
if [[ "${PROBLEM_DIR%/}" == *-SQL ]]; then
    echo "Error: 'check' is not supported for SQL problems"
    exit 1
fi

# Check if check script exists
if [ ! -f "$PROBLEM_DIR/scripts/check.sh" ]; then
    echo "Error: Check script not found for problem directory '$PROBLEM_DIR'"
    exit 1
fi

# Run checks
echo "⚡ Checking solution of problem $PROBLEM_DIR..."
"$PROBLEM_DIR/scripts/check.sh"

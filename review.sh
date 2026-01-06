#!/bin/bash

# Check if problem directory is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <problem-directory>"
    exit 1
fi

PROBLEM_DIR=$1

echo "⚡ Reviewing problem $PROBLEM_DIR..."
docker exec opencode opencode run --command leetup-review "$PROBLEM_DIR"
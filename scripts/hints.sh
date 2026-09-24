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

echo "⚡ Generating hints for problem $PROBLEM_DIR..."
docker exec opencode opencode run --command leetup-hints "$PROBLEM_DIR"

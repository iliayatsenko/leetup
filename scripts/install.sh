#!/bin/bash

# Check if problem directory is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <problem-directory>"
    exit 1
fi

PROBLEM_DIR=$1

# Check if install script exists
if [ ! -f "$PROBLEM_DIR/scripts/install.sh" ]; then
    echo "Error: Install script not found for problem directory '$PROBLEM_DIR'"
    exit 1
fi

# Install the declared dependencies
echo "⚡ Installing dependencies of problem $PROBLEM_DIR..."
cd "$PROBLEM_DIR" || { echo "Error: Unable to change directory to '$PROBLEM_DIR'"; exit 1; }
./scripts/install.sh

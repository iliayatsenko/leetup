#!/bin/bash

# Go-specific setup for LeetCode problems
# This script is sourced by setup.sh
# Expected variables:
#   - RESPONSE: JSON response from LeetCode API
#   - PROBLEM_SLUG: The problem slug
# Expected functions:
#   - cleanup_text: Clean up text fetched from LeetCode API
#   - render_template: Write a template to stdout, expanding placeholders
#   - render_scripts: Render every script template of a language into the problem directory

# Directory holding the Go templates
TEMPLATE_DIR=$(dirname "${BASH_SOURCE[0]}")

# Append environment details to problem description
printf "\n\n---\n\n### Environment:" >> problem.md
echo "$RESPONSE" | jq -r '.question.envInfo' | jq -r '.golang.[1]' | cleanup_text | pandoc -f html -t markdown >> problem.md

# Create go.mod file
if [ ! -f go.mod ]; then
    render_template "$TEMPLATE_DIR/go.mod.tmpl" > go.mod
fi

# Create solution file if it doesn't exist and write Golang code snippet
if [ ! -f solution.go ]; then
    render_template "$TEMPLATE_DIR/solution.go.tmpl" > solution.go
    echo "$RESPONSE" | jq -r '.question.codeSnippets[] | select(.langSlug=="golang") | .code' >> solution.go
fi

# Create scripts to run tests and debug session, along with the
# check.sh and debug.sh entry points calling them
render_scripts "$TEMPLATE_DIR"

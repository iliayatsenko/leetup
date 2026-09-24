#!/bin/bash

# PHP-specific setup for LeetCode problems
# This script is sourced by setup.sh
# Expected variables:
#   - RESPONSE: JSON response from LeetCode API
#   - PROBLEM_SLUG: The problem slug
# Expected functions:
#   - cleanup_text: Clean up text fetched from LeetCode API
#   - render_template: Write a template to stdout, expanding placeholders
#   - render_scripts: Render every script template of a language into the problem directory

# Directory holding the PHP templates
TEMPLATE_DIR=$(dirname "${BASH_SOURCE[0]}")

# Append environment details to problem description
printf "\n\n---\n\n### Environment:" >> problem.md
echo "$RESPONSE" | jq -r '.question.envInfo' | jq -r '.php.[1]' | cleanup_text | pandoc -f html -t markdown >> problem.md

# Create composer.json file
if [ ! -f composer.json ]; then
    render_template "$TEMPLATE_DIR/composer.json.tmpl" > composer.json
fi

# Create solution file if it doesn't exist and write PHP code snippet
if [ ! -f solution.php ]; then
    render_template "$TEMPLATE_DIR/solution.php.tmpl" > solution.php
    echo "$RESPONSE" | jq -r '.question.codeSnippets[] | select(.langSlug=="php") | .code' >> solution.php
fi

# Create the script running the tests, along with the installdeps.sh, check.sh and
# debug.sh entry points
render_scripts "$TEMPLATE_DIR"

# Install the shared test tooling if missing and this problem's own dependencies,
# through the same entry point the solver uses later
./scripts/installdeps.sh

#!/bin/bash

# JavaScript-specific setup for LeetCode problems
# This script is sourced by setup.sh
# Expected variables:
#   - RESPONSE: JSON response from LeetCode API
#   - PROBLEM_SLUG: The problem slug
# Expected functions:
#   - cleanup_text: Clean up text fetched from LeetCode API
#   - render_template: Write a template to stdout, expanding placeholders
#   - render_scripts: Render every script template of a language into the problem directory

# Directory holding the JavaScript templates
TEMPLATE_DIR=$(dirname "${BASH_SOURCE[0]}")

# Append environment details to problem description
printf "\n\n---\n\n### Environment:" >> problem.md
echo "$RESPONSE" | jq -r '.question.envInfo' | jq -r '.javascript.[1]' | cleanup_text | pandoc -f html -t markdown >> problem.md

# Create package.json file
if [ ! -f package.json ]; then
    render_template "$TEMPLATE_DIR/package.json.tmpl" > package.json
fi

# Create solution file if it doesn't exist and write JavaScript code snippet
if [ ! -f solution.js ]; then
    render_template "$TEMPLATE_DIR/solution.js.tmpl" > solution.js
    echo "$RESPONSE" | jq -r '.question.codeSnippets[] | select(.langSlug=="javascript") | .code' >> solution.js

    # LeetCode snippets export nothing, so export the function (or class) the
    # snippet declares first, for the tests to require it
    NAME=$(sed -nE 's/^var ([A-Za-z_$][A-Za-z0-9_$]*) = function.*/\1/p' solution.js | head -n 1)
    if [ -n "$NAME" ]; then
        printf "\nmodule.exports = { %s };\n" "$NAME" >> solution.js
    else
        echo "Warning: could not detect the solution name, add module.exports to solution.js by hand"
    fi
fi

# Create the scripts running and debugging the tests, along with the installdeps.sh,
# check.sh and debug.sh entry points
render_scripts "$TEMPLATE_DIR"

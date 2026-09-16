#!/bin/bash

# Check if language and problem slug or link are provided
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <language> <problem-slug-or-link>"
    echo "Examples:"
    echo "  $0 go two-sum"
    echo "  $0 js https://leetcode.com/problems/two-sum/"
    exit 1
fi

# Get language parameter
LANGUAGE=$1

# Validate that language setup file exists
LANG_SETUP_FILE="setup/$LANGUAGE/setup.sh"
if [ ! -f "$LANG_SETUP_FILE" ]; then
    echo "Error: Language '$LANGUAGE' is not supported yet"
    echo "Missing language setup file: $LANG_SETUP_FILE"
    exit 1
fi

# Extract slug from URL if a link is provided, otherwise use as-is
INPUT=$2
if [[ "$INPUT" =~ leetcode\.com/problems/([^/]+) ]]; then
    PROBLEM_SLUG="${BASH_REMATCH[1]}"
else
    PROBLEM_SLUG=$INPUT
fi

echo "⚡ Fetching problem $PROBLEM_SLUG..."
# Fetch problem data
RESPONSE=$(curl --silent "http://leetcode-api:3000/select/raw?titleSlug=$PROBLEM_SLUG")

# Check if response is not empty
if [ -z "$RESPONSE" ]; then
    echo "Error: Failed to fetch problem data"
    exit 1
fi

# Prepare directory
ID=$(echo "$RESPONSE" | jq -r '.question.questionId')
LANG_UPPER=$(echo "$LANGUAGE" | tr '[:lower:]' '[:upper:]')
PROBLEM_DIR="$ID-$PROBLEM_SLUG-$LANG_UPPER"
mkdir -p "$PROBLEM_DIR" || { echo "Failure to create directory"; exit 1; }
cd "$PROBLEM_DIR" || { echo "Failure to change directory"; exit 1; }

# Extract problem details from API (https://alfaarghya.github.io/alfa-leetcode-api/)
TITLE=$(echo "$RESPONSE" | jq -r '.question.title')
LINK="https://leetcode.com/problems/$PROBLEM_SLUG/"
DIFFICULTY=$(echo "$RESPONSE" | jq -r '.question.difficulty')
TAGS=$(echo "$RESPONSE" | jq -r '.question.topicTags[].name' | sed 's/^/- /;s/$/\n/')

echo "⚡ Writing files..."
# Create problem file and write details
printf "# %d. %s\n\n[%s](%s)\n\n**Difficulty:** %s\n" "$ID" "$TITLE" "$LINK" "$LINK" "$DIFFICULTY" > problem.md
if [ -n "$TAGS" ]; then
    printf "\n**Tags:**\n\n%s\n" "$TAGS" >> problem.md
fi
printf "\n\n---\n\n" >> problem.md

# Function to clean up text (exported for use in language-specific scripts)
cleanup_text() {
    sed 's/\\n/ /g;s/\\r/ /g;s/\\t/ /g;s/\&nbsp;/ /g'
}
export -f cleanup_text

# Function to write a template to stdout, expanding placeholders
# (exported for use in language-specific scripts)
render_template() {
    sed -e "s|{{PROBLEM_SLUG}}|$PROBLEM_SLUG|g" \
        -e "s|{{HOST_PROJECT_PATH}}|$HOST_PROJECT_PATH|g" \
        "$1"
}
export -f render_template

# Function to render every script template of the given language directory into the
# scripts directory of the problem (exported for use in language-specific scripts)
render_scripts() {
    mkdir -p scripts
    for template in "$1"/*.sh.tmpl; do
        script="scripts/$(basename "$template" .tmpl)"
        render_template "$template" > "$script"
        chmod +x "$script"
    done
}
export -f render_scripts

# Extract, format and write problem description
echo "$RESPONSE" | jq -r '.question.content' | cleanup_text | pandoc -f html -t markdown >> problem.md

# Extract, format and write hints if available
HINTS_COUNT=$(echo "$RESPONSE" | jq -r '.question.hints | length')
if [ "$HINTS_COUNT" -gt 0 ]; then
    mkdir -p hints
    # Index the hints instead of reading line by line, so multiline hints stay in one file
    for ((i = 0; i < HINTS_COUNT; i++)); do
        echo "$RESPONSE" | jq -r ".question.hints[$i]" | cleanup_text | pandoc -f html -t markdown > "hints/hint$((i + 1)).md"
    done
fi

# Source language-specific setup
source "../$LANG_SETUP_FILE"

echo "⚡ Generating tests..."
docker exec opencode opencode run --print-logs --command leetup-tests "$PROBLEM_DIR"
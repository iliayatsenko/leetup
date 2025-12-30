#!/bin/bash

# Go-specific setup for LeetCode problems
# This script is sourced by setup.sh
# Expected variables:
#   - RESPONSE: JSON response from LeetCode API
#   - PROBLEM_SLUG: The problem slug

# Append environment details to problem description
printf "\n\n---\n\n### Environment:" >> problem.md
echo "$RESPONSE" | jq -r '.question.envInfo' | jq -r '.golang.[1]' | cleanup_text | pandoc -f html -t markdown >> problem.md

# Create go.mod file
if [ ! -f go.mod ]; then
    cat > go.mod <<EOF
module leetcode/$PROBLEM_SLUG

go 1.23
EOF
fi

# Create solution file if it doesn't exist and write Golang code snippet
if [ ! -f solution.go ]; then
    printf "package main\n\n" > solution.go
    echo "$RESPONSE" | jq -r '.question.codeSnippets[] | select(.langSlug=="golang") | .code' >> solution.go
fi

# Create check.sh script to run checks
cat > check.sh <<'EOF'
#!/bin/bash

# Check if Go is installed
if ! command -v go &> /dev/null; then
    echo "Go is not installed in leetup container. Installing..."

    apk add --no-cache go

    # Verify installation
    if ! command -v go &> /dev/null; then
        echo "Go installation failed."
        exit 1
    fi

    echo "Go installed successfully: $(go version)"
fi

# Run Go tests with verbose output
go test -v ./...
EOF

chmod +x check.sh

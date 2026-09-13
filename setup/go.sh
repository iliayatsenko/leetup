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

# go existence check
go_check=$( cat <<'GO_CHECK'
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
GO_CHECK
)

# Create check.sh script to run checks
cat > check.sh <<CHECK_EOF
#!/bin/bash
$go_check
# Run Go tests with verbose output
go test -v ./...
CHECK_EOF

# Create debug.sh script to run debug session
cat > debug.sh <<DEBUG_EOF
#!/bin/bash
$go_check
# Check if delve is installed
if ! command -v ~/go/bin/dlv &> /dev/null; then
  go install github.com/go-delve/delve/cmd/dlv@latest
fi

# Write delve configuration
cat > ~/.config/dlv/config.yml <<'DELVE_EOF'
substitute-path:
  - {from: /workspace, to: $HOST_PROJECT_PATH}
DELVE_EOF

# Run dlv session with go tests. See how to connect to it from GoLand IDE here: https://www.jetbrains.com/help/go/attach-to-running-go-processes-with-debugger.html#step-2-create-the-go-remote-run-debug-configuration
~/go/bin/dlv test . --listen=:40000 --headless=true --api-version=2
DEBUG_EOF

chmod +x check.sh
chmod +x debug.sh

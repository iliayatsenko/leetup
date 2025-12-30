#!/bin/bash

# PHP-specific setup for LeetCode problems
# This script is sourced by setup.sh
# Expected variables:
#   - RESPONSE: JSON response from LeetCode API
#   - PROBLEM_SLUG: The problem slug

# Append environment details to problem description
printf "\n\n---\n\n### Environment:" >> problem.md
echo "$RESPONSE" | jq -r '.question.envInfo' | jq -r '.php.[1]' | cleanup_text | pandoc -f html -t markdown >> problem.md

# Create composer.json file
if [ ! -f composer.json ]; then
    cat > composer.json <<EOF
{
    "name": "leetcode/$PROBLEM_SLUG",
    "require": {
        "php": "^8.2"
    },
    "require-dev": {
        "phpunit/phpunit": "^10.0"
    }
}
EOF
fi

# Create solution file if it doesn't exist and write PHP code snippet
if [ ! -f solution.php ]; then
    printf "<?php\n\n" > solution.php
    echo "$RESPONSE" | jq -r '.question.codeSnippets[] | select(.langSlug=="php") | .code' >> solution.php
fi

# Create tests directory if it doesn't exist
if [ ! -d tests ]; then
    mkdir tests
fi

# Add .gitignore file
if [ ! -f .gitignore ]; then
    echo "vendor" > .gitignore
fi

# Create check.sh script to run checks
cat > check.sh <<'EOF'
#!/bin/bash

# Check if PHP is installed
if ! command -v php &> /dev/null; then
    echo "PHP is not installed in leetup container. Installing..."

    apk update
    apk add --no-cache php php-cli php-mbstring php-xml php-dom php-ctype php-tokenizer php-xmlwriter php-phar php-json php-iconv php-openssl

    # Verify installation
    if ! command -v php &> /dev/null; then
        echo "PHP installation failed."
        exit 1
    fi

    echo "PHP installed successfully: $(php --version)"
fi

# Check if Composer is installed
if ! command -v composer &> /dev/null; then
    echo "Composer is not installed. Installing..."

    apk add --no-cache composer

    # Verify installation
    if ! command -v composer &> /dev/null; then
        echo "Composer installation failed."
        exit 1
    fi

    echo "Composer installed successfully: $(composer --version)"
fi

# Install dependencies if vendor directory doesn't exist
if [ ! -d vendor ]; then
    composer install --no-interaction
fi

# Run PHPUnit tests
if [ -d tests ]; then
    ./vendor/bin/phpunit tests
else
    echo "No tests directory found. Please create tests for your solution."
fi
EOF

chmod +x check.sh
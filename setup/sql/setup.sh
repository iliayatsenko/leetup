#!/bin/bash

# SQL (MySQL) setup for LeetCode database problems
# This script is sourced by setup.sh
# Expected variables:
#   - RESPONSE: JSON response from LeetCode API
#   - ID: The problem id
#   - PROBLEM_SLUG: The problem slug
# Expected functions:
#   - cleanup_text: Clean up text fetched from LeetCode API
#
# SQL problems have no tests and no scripts: the first example is loaded into a
# database in the mysql container, and the solution is run from a DB client by hand

# Named after the problem, cut to the 64 characters MySQL allows. The dashes make
# backticks necessary in SQL
DATABASE="$ID-$PROBLEM_SLUG"
DATABASE="${DATABASE:0:64}"

# The mysql:// DSN is for the mysql client and most tools, JetBrains IDEs and other
# Java tools only take JDBC URLs
DSN="mysql://root:leetup@localhost:${MYSQL_PORT:-3306}/$DATABASE"
JDBC_URL="jdbc:mysql://localhost:${MYSQL_PORT:-3306}/$DATABASE?user=root&password=leetup"

# Append environment details to problem description
printf "\n\n---\n\n### Environment:" >> problem.md
echo "$RESPONSE" | jq -r '.question.envInfo' | jq -r '.mysql.[1]' | cleanup_text | pandoc -f html -t markdown >> problem.md

# Function to run the SQL from stdin in the mysql container. It goes through the
# Docker socket, so the leetup container needs neither a mysql client nor a
# connection to the database
run_mysql() {
    docker exec -i -e MYSQL_PWD=leetup leetup-mysql mysql -uroot
}

# Function to print the table that follows the first "Output:" line of its input
first_output_table() {
    local found=false line
    while IFS= read -r line; do
        if [[ "$line" == *Output:* ]]; then
            found=true
        elif $found && [[ "$line" =~ ^\ *[+|] ]]; then
            echo "$line"
        elif $found; then
            break
        fi
    done
}

# Load LeetCode's schema of the problem, its tables and the rows of the first example,
# into a fresh database, so running setup again resets the data
SCHEMA=$(echo "$RESPONSE" | jq -r '.question.mysqlSchemas[] + ";"')
echo "DROP DATABASE IF EXISTS \`$DATABASE\`; CREATE DATABASE \`$DATABASE\`; USE \`$DATABASE\`; $SCHEMA" | run_mysql \
    || { echo "Error: Failed to load the problem schema into the leetup-mysql container"; exit 1; }

# Create solution file if it doesn't exist: the connection details, the expected output
# of the first example and the MySQL code snippet
if [ ! -f solution.sql ]; then
    DESCRIPTION=$(echo "$RESPONSE" | jq -r '.question.content' | cleanup_text | pandoc -f html -t plain)
    SNIPPET=$(echo "$RESPONSE" | jq -r '.question.codeSnippets[] | select(.langSlug=="mysql") | .code')
    {
        echo "-- Database: $DSN"
        echo "-- JDBC URL: $JDBC_URL"
        echo
        echo "-- Expected output:"
        echo "$DESCRIPTION" | first_output_table | sed 's/^ */-- /'
        echo "USE \`$DATABASE\`;"
        echo "$SNIPPET"
    } > solution.sql
fi

echo "⚡ Database: $DSN"
echo "⚡ JDBC URL: $JDBC_URL"

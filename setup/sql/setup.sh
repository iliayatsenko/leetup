#!/bin/bash

# SQL (PostgreSQL) setup for LeetCode database problems
# This script is sourced by setup.sh
# Expected variables:
#   - RESPONSE: JSON response from LeetCode API
#   - ID: The problem id
# Expected functions:
#   - cleanup_text: Clean up text fetched from LeetCode API
#
# SQL problems have no tests and no scripts: every example is loaded into its own
# schema in the postgres container, solution.sql gets a block per example with its
# expected output and the query switching to its schema, and the solution is run
# from a DB client by hand

# Append environment details to problem description
printf "\n\n---\n\n### Environment:" >> problem.md
echo "$RESPONSE" | jq -r '.question.envInfo' | jq -r '.postgresql.[1]' | cleanup_text | pandoc -f html -t markdown >> problem.md

META=$(echo "$RESPONSE" | jq -r '.question.metaData')
EXAMPLES=$(echo "$RESPONSE" | jq -c '.question.exampleTestcases | split("\n") | map(select(length > 0) | fromjson)')
EXAMPLES_COUNT=$(echo "$EXAMPLES" | jq 'length')

# Write one self-contained file per example: the tables and their example rows.
# LeetCode's own PostgreSQL DDL is used when the problem has one, otherwise it is
# built from the dialect-neutral database_schema, whose types are MySQL ones
if [ ! -d examples ]; then
    mkdir -p examples
    for ((i = 0; i < EXAMPLES_COUNT; i++)); do
        echo "$EXAMPLES" | jq -r --argjson meta "$META" --argjson i "$i" '
            def pg_type:
                ascii_upcase
                | if test("^ENUM") then "VARCHAR"
                  elif test("^DATETIME") then "TIMESTAMP"
                  elif test("^TINYINT") then "SMALLINT"
                  elif test("^(FLOAT|DOUBLE)") then "DOUBLE PRECISION"
                  elif test("^DECIMAL") then sub("^DECIMAL"; "NUMERIC")
                  elif test("^(BIG|SMALL)?INT\\(") then sub("\\(.*"; "")
                  else . end;
            def literal:
                if . == null then "NULL"
                elif type == "string" then "'\''" + gsub("'\''"; "'\'''\''") + "'\''"
                else tostring end;

            (if ($meta.postgresql | length) > 0 then
                $meta.postgresql[] | sub("[;\\s]*$"; ";")
            else
                $meta.database_schema | to_entries[]
                | "CREATE TABLE \(.key) (\([.value | to_entries[] | "\(.key) \(.value | pg_type)"] | join(", ")));"
            end),
            "",
            (.[$i] as $example | $example.headers | to_entries[]
                | select(($example.rows[.key] // []) | length > 0)
                | "INSERT INTO \(.key) (\(.value | join(", "))) VALUES\n"
                  + ([$example.rows[.key][] | "    (\(map(literal) | join(", ")))"] | join(",\n"))
                  + ";")
        ' > "examples/example$((i + 1)).sql"
    done
fi

# Load every example into its own schema. They are dropped first, so running setup
# again resets the data, e.g. after trying an UPDATE or DELETE solution. The load goes
# through the Docker socket, so the leetup container needs neither psql nor a
# connection to postgres
SCHEMAS=()
LOAD_SQL="SET client_min_messages TO warning;"$'\n'
for file in examples/example*.sql; do
    [ -f "$file" ] || continue
    SCHEMA="p${ID}_$(basename "$file" .sql)"
    SCHEMAS+=("$SCHEMA")
    LOAD_SQL+="DROP SCHEMA IF EXISTS $SCHEMA CASCADE;"$'\n'"CREATE SCHEMA $SCHEMA;"$'\n'"SET search_path TO $SCHEMA;"$'\n'"$(cat "$file")"$'\n'
done
echo "$LOAD_SQL" | docker exec -i leetup-postgres psql -X -q -v ON_ERROR_STOP=1 --single-transaction -U leetup -d leetup \
    || { echo "Error: Failed to load the examples into the leetup-postgres container"; exit 1; }

# Create solution file if it doesn't exist: one block per example, holding its
# expected output taken from the problem description, the query switching to its
# schema and the PostgreSQL code snippet
if [ ! -f solution.sql ]; then
    SNIPPET=$(echo "$RESPONSE" | jq -r '.question.codeSnippets[] | select(.langSlug=="postgresql") | .code')
    # The snippet goes through the environment, as awk -v would expand its escapes
    echo "$RESPONSE" | jq -r '.question.content' | cleanup_text | pandoc -f html -t plain | SNIPPET="$SNIPPET" awk -v id="$ID" '
        function close_block() {
            printf "SET search_path TO p%s_example%d;\n%s\n", id, n, ENVIRON["SNIPPET"]
            in_output = 0
        }
        /Output:/ {
            if (in_output) close_block()
            n++; in_output = 1; in_table = 0
            printf "%s-- Example %d\n-- Expected output:\n", (n > 1 ? "\n" : ""), n
            next
        }
        in_output && /^[[:space:]]*[+|]/ { sub(/^[[:space:]]+/, ""); print "-- " $0; in_table = 1; next }
        in_output && in_table { close_block() }
        END { if (in_output) close_block() }
    ' > solution.sql

    OUTPUTS_COUNT=$(grep -c '^-- Example ' solution.sql)
    if [ "$OUTPUTS_COUNT" -ne "$EXAMPLES_COUNT" ]; then
        echo "Warning: found $OUTPUTS_COUNT expected outputs for $EXAMPLES_COUNT examples, check solution.sql against problem.md"
    fi
fi

# The libpq DSN is for psql and most clients, JetBrains IDEs and other Java tools
# only take JDBC URLs. The example schemas are picked in solution.sql instead
echo "⚡ Database: postgresql://leetup:leetup@localhost:${POSTGRES_PORT:-5432}/leetup"
echo "⚡ JDBC URL: jdbc:postgresql://localhost:${POSTGRES_PORT:-5432}/leetup?user=leetup&password=leetup"
echo "⚡ Schemas:  ${SCHEMAS[*]}"

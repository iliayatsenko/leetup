# Plan: database (SQL) problems on PostgreSQL

## Context
leetup handles Go, PHP and JS problems. LeetCode database problems (e.g. `combine-two-tables`) fail at setup, because `scripts/setup.sh:51-59` finds no snippet for the language. We want `docker exec leetup setup sql combine-two-tables` to create a problem directory and a ready-to-query database. There's no automated checking:
- Setup loads each example's tables and data into a new postgres container, one schema per example.
- Setup copies each example's expected "Output" table into `solution.sql` as a comment.
- The user runs `solution.sql` from their IDE or DB client and compares the result with the comment by eye.
- `check`, `debug` and `installdeps` are disabled for SQL problems.

## What the API gives us (checked on `combine-two-tables`)
- `questionId` (175), `codeSnippets[langSlug=postgresql]`: `-- Write your PostgreSQL query statement below`
- `envInfo.postgresql[1]`: "PostgreSQL 16"
- `metaData` (a JSON string): `database_schema: {Table: {col: "MYSQL TYPE"}}`
- `exampleTestcases`: one JSON per line, one line per example, in the form `{"headers":{T:[cols]},"rows":{T:[[...]]}}`.
- `content` (HTML): each example's `<pre>` holds an `Output:` ASCII table (`+---+` / `| a |` lines).

## Decisions
- The language argument is `sql`. It gives the dir suffix `-SQL`, the template folder `setup/sql/`, and maps to LeetCode slug `postgresql`.
- The postgres image is `postgres:16-alpine`, matching LeetCode.
  - A named volume `postgres-data` keeps the loaded examples across `docker compose down`/`up`.
- Everything is done in shell and jq, like the other `setup.sh` files. No Go or deps are needed.
- There is one schema per example, named `p{ID}_example{N}` (e.g. `p175_example1`), so examples never clash.
  - Setup always reloads them, even when the files already exist: `DROP SCHEMA IF EXISTS … CASCADE; CREATE SCHEMA …; SET search_path …; \i examples/exampleN.sql`.
  - This means running setup again resets the data, for example after testing an UPDATE/DELETE solution.
- Example files are self-contained: `examples/exampleN.sql` has `CREATE TABLE` plus `INSERT` and no schema name. It's the source of truth, and the user can reload one by hand.
  - Column order comes from `headers`, and column types come from `metaData.database_schema`.
  - Types are converted in jq: `ENUM(...)`→`VARCHAR`, `DATETIME`→`TIMESTAMP`, `TINYINT`→`SMALLINT`, `FLOAT`/`DOUBLE`→`DOUBLE PRECISION`, `DECIMAL`→`NUMERIC`, `INT(n)`→`INT`. Anything else passes through unchanged.
  - Values: strings get `''` escaping and quotes, null becomes `NULL`, and numbers stay as-is.
  - Identifiers stay unquoted, the same as LeetCode's postgres setup.
- `leetup` doesn't connect to postgres over the network, and there's no psql client in the leetup image.
  - Loading goes through the Docker socket, the same way setup already calls opencode: `docker exec -i leetup-postgres psql -X -q -v ON_ERROR_STOP=1 -U leetup -d leetup < …`.
  - `leetup-postgres` has its own psql.
- At the end, setup prints the connection DSN and the schemas, e.g.:
  ```
  Database: postgresql://leetup:leetup@localhost:5432/leetup
  Schemas:  p175_example1, p175_example2
  ```
  The port comes from `POSTGRES_PORT`, which is passed into the `leetup` container.

## Resulting problem dir
```
175-combine-two-tables-SQL/
  problem.md, hints/
  solution.sql           # expected outputs as comments + postgresql snippet
  examples/example1.sql  # CREATE TABLE + INSERT (loaded into schema p175_example1)
```
There's no `scripts/` dir.

Example `solution.sql`:
```sql
-- Example 1: SET search_path TO p175_example1;
-- Expected output:
-- +-----------+----------+---------------+
-- | firstName | lastName | city          |
-- +-----------+----------+---------------+
-- | Allen     | Wang     | Null          |
-- | Bob       | Alice    | New York City |
-- +-----------+----------+---------------+

-- Write your PostgreSQL query statement below
```

## Files

### Infrastructure
- `docker-compose.yaml`:
  - Add a `postgres` service: `container_name: leetup-postgres`, `POSTGRES_USER/PASSWORD/DB=leetup`, port `${POSTGRES_PORT:-5432}:5432`, the `postgres-data` volume, and a `pg_isready` healthcheck.
  - `leetup` gets only `POSTGRES_PORT=${POSTGRES_PORT:-5432}` in `environment`, used to print the DSN.
  - `leetup` depends on `postgres` with `condition: service_healthy`, so the container is up when setup runs `docker exec`.
  - Add a top-level `volumes: postgres-data:`.
- `Dockerfile`: no change.
- `.env.dist`: add `#POSTGRES_PORT=5432` under "Published ports". This is the only new env var.

### `setup/sql/setup.sh` (new; follows `setup/js/setup.sh`)
Sourced by `scripts/setup.sh`, which already has `ID` and `RESPONSE`.
1. Append the envInfo line to `problem.md` (`.postgresql.[1]`).
2. If `examples/` is missing, write `examples/exampleN.sql`, one per line of `exampleTestcases`, using jq with the type mapping above.
3. Load every `examples/exampleN.sql` into schema `p${ID}_exampleN` through `docker exec -i leetup-postgres psql`, as described above.
4. Create `solution.sql` if it's missing:
   - Take the Output tables: convert `content` to plain text with `pandoc -f html -t plain`, then use awk to keep the `+`/`|` lines that follow each `Output:`.
   - For each example, write a comment block with the `SET search_path` line and the expected output.
   - Append the postgresql snippet.
   - Warn if the number of Output tables doesn't match the number of examples.
5. Don't call `render_scripts`, because there are no script templates.
6. Print the DSN and schema list.

### Existing files
- `scripts/setup.sh`:
  - Lines 51-55: add `sql) LANG_SLUG="postgresql" ;;`, and a `sql` line to the usage text at 7-9.
  - Lines 119-137: skip opencode test generation when `LANGUAGE=sql`.
- `scripts/check.sh`, `scripts/debug.sh` and `scripts/installdeps.sh`: before the "script not found" check, stop `*-SQL` dirs with `Error: '<cmd>' is not supported for SQL problems` and exit 1.
- `.opencode/agent/leetup-reviewer.md:11`: add `-SQL` → `solution.sql`, plus a note to review index use and the query plan instead of Big-O.
- `README.md`: language list (9, 11), setup example (35-40), and a short "SQL" section covering:
  - The files in the dir and the schema-per-example layout.
  - Connecting a DB client with the DSN that setup prints.
  - That rerunning setup resets the data.
  - That `check`/`debug`/`installdeps` aren't available.

  Also add a `POSTGRES_PORT` row to the config table (159-170).
- `CLAUDE.md`: add `SQL` to the language lists and describe the `solution.sql` + `examples/` layout. Note that SQL has no `solution_test` file or scripts, so it's an exception to the Workflow rule.
- Save this plan as `plans/sql-support.md` in the repo; there's no Jira ticket for this personal repo. Add `.claude/rules/adding-a-language.md` with the reusable pattern: `setup/<lang>/setup.sh` + templates, the `LANG_SLUG` mapping, and runtime env instead of baked-in values.

## Verification
1. Run `docker compose up -d --build` and check that `leetup-postgres` is healthy.
2. Run `docker exec leetup setup sql combine-two-tables`. It should print the DSN and schemas. Check `examples/example1.sql` and the comment blocks in `solution.sql`.
3. From the host, connect with the printed DSN and run `SELECT * FROM p175_example1.person`. Then run the known answer with `search_path` set and compare the result with the comment.
4. Set `POSTGRES_PORT=5433` in `.env` and recreate the containers. The printed DSN and the host port should both change.
5. Run setup on `rising-temperature` (DATE) and `delete-duplicate-emails`. Delete a row by hand, rerun setup and confirm the data is reset.
6. Run `docker compose down && docker compose up -d`. The schemas should still be there.
7. Run `setup sql two-sum`. It should still fail with the "no code snippet" error.
8. Run `check`, `debug` and `installdeps` on the SQL dir. All three should stop with the "not supported for SQL problems" error.
9. Run `check 1-two-sum-GO` / `-PHP` / `-JS` to confirm nothing else broke.

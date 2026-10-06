# leetup

LeetCode practice environment with solutions in Go, PHP, JavaScript and SQL (MySQL). Everything runs inside the `leetup` Docker container; see README.md.

## Structure

Each problem lives in its own directory: `{id}-{problem-slug}-{LANG}/` (`LANG` is `GO`, `PHP`, `JS` or `SQL`)
- `problem.md`, `hints/` — fetched from LeetCode by `setup`
- `solution.go` (`package main`), `solution.php` (`class Solution`) or `solution.js` (CommonJS, ends with `module.exports`) — implementation
- `solution_test.go` / `solution_test.php` / `solution_test.js` (`node:test`) — table-based tests, one case per example
- `scripts/` — generated from `setup/<lang>/*.sh.tmpl`; don't edit by hand, change the template
- SQL: `solution.sql` (connection details and expected output of the first example as comments, `USE <database>`, the snippet); setup loads the problem's `mysqlSchemas` (tables + first example rows) into database `{id}-{slug}` (max 64 chars, needs backticks in SQL) of the `leetup-mysql` container. No tests, no `scripts/`, so `check`, `debug` and `installdeps` refuse `-SQL` dirs
- Go: own `go.mod`, no root module. PHP: own `composer.json` and `vendor`; PHPUnit is shared under `deps/php`. JS: own `package.json` and `node_modules`; tests use the built-in runner, no packages

## Commands

```bash
docker exec leetup setup go two-sum            # new problem
docker exec leetup installdeps 1-two-sum-GO    # install declared dependencies
docker exec leetup check 1-two-sum-GO          # run tests
docker exec leetup debug 1-two-sum-GO          # debug session for the IDE
```

## Workflow

- Work on the `solutions` branch
- Add new problems with `setup`, not by hand
- Each solution must have a corresponding `solution_test.<lang>`, except SQL ones
- AI skills (tests, hints, review, adding a language) live in `.agents/skills/<name>/SKILL.md`. `.claude/skills` is a symlink to it, and `.opencode/command/` loads the same files as agent prompts (provider config lives in the gitignored `opencode.jsonc`, copied from `opencode.jsonc.dist`; run agents through `.opencode/run-command-if-configured.sh` in the opencode container), so edit only the `SKILL.md`

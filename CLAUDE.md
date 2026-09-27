# leetup

LeetCode practice environment with solutions in Go, PHP and JavaScript. Everything runs inside the `leetup` Docker container; see README.md.

## Structure

Each problem lives in its own directory: `{id}-{problem-slug}-{LANG}/` (`LANG` is `GO`, `PHP` or `JS`)
- `problem.md`, `hints/` — fetched from LeetCode by `setup`
- `solution.go` (`package main`), `solution.php` (`class Solution`) or `solution.js` (CommonJS, ends with `module.exports`) — implementation
- `solution_test.go` / `solution_test.php` / `solution_test.js` (`node:test`) — table-based tests, one case per example
- `scripts/` — generated from `setup/<lang>/*.sh.tmpl`; don't edit by hand, change the template
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
- Each solution must have a corresponding `solution_test.<lang>`

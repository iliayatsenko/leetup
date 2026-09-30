# LeetUp

A streamlined LeetCode practice environment with automatic problem setup and multi-language support.

## Features

- Fetch LeetCode problems automatically from API
- Generate problem descriptions, hints, and test scaffolding
- Support for several programming languages (Go, PHP, JavaScript), plus database problems on MySQL
- Run tests with a single command
- Debug solutions from the IDE with delve (Go), Xdebug (PHP) and the Node inspector (JavaScript)

## Usage

### 1. Configure the environment

```bash
cp .env.dist .env
```

Fill in the opencode provider, model and API key. Everything else in `.env` is optional — the published ports, the Xdebug target and the IDE identifiers all have defaults, so uncomment them only where this machine differs. See [Configuration](#configuration) for what each one does.

### 2. Start the environment

```bash
docker-compose up -d
```

### 3. Setup a new problem

```bash
docker exec leetup setup <language> <problem-slug-or-link>
```

Examples:
```bash
docker exec leetup setup go two-sum
docker exec leetup setup php https://leetcode.com/problems/two-sum/
docker exec leetup setup js two-sum
docker exec leetup setup sql combine-two-tables
```

Setup also generates `solution_test.<lang>` from the problem's examples, unless the problem already has one. Database problems work differently, see [SQL problems](#sql-problems).

### 4. Regenerate unit tests (optional)

To regenerate the tests, delete `solution_test.<lang>` and run in the opencode terminal:

```
/leetup-tests <problem-directory>
```

Example:
```
/leetup-tests 1-two-sum-GO
```

### 5. Implement your solution in the `solution.<lang>` file

### 6. Install dependencies

Declare what the solution needs first — imports in Go, the `require` section of `composer.json` in PHP, the `dependencies` section of `package.json` in JavaScript — then install them:

```bash
docker exec leetup installdeps <problem-directory>
```

Examples:
```bash
docker exec leetup installdeps 1-two-sum-GO
docker exec leetup installdeps 1-two-sum-PHP
docker exec leetup installdeps 1-two-sum-JS
```

Go runs `go mod tidy`, syncing `go.mod` and `go.sum` with the imports found in the code. Modules are downloaded into the Go module cache at its default location inside the container, which is content-addressed, so problems cannot interfere with each other there. The cache lives in the container rather than the workspace, so recreating the container means downloading the modules again.

PHP installs two layers separately:

| Layer | Manifest | Installed into |
| --- | --- | --- |
| Test tooling, shared | `deps/php/composer.json` | `deps/php/vendor`, once |
| The solution's own deps | `<problem-directory>/composer.json` | `<problem-directory>/vendor` |

Each problem has its own `vendor`, so installing one problem never removes another's packages. Only PHPUnit is shared. It lives under `/workspace` rather than in the image so the IDE can resolve its sources while debugging (a phar can't be mapped to files on disk).

JavaScript runs `npm install` into the problem's own `node_modules`. Tests use Node's built-in `node:test` runner, so there is no test tooling to install and a fresh problem declares no packages at all. `setup` appends `module.exports` for the function (or class) the LeetCode snippet declares, so the test can `require` it.

### 7. Run tests

```bash
docker exec leetup check <problem-directory>
```

Example:
```bash
docker exec leetup check 1-two-sum-GO
```

### 8. Debug your solution

```bash
docker exec leetup debug <problem-directory>
```

Example:
```bash
docker exec leetup debug 1-two-sum-GO
```

The command starts a debug session running the tests and waits for the IDE to attach:

- Go — headless delve session, reachable on the host at `DELVE_PORT`
- PHP — Xdebug connecting out to the IDE listener at `XDEBUG_CLIENT_HOST:XDEBUG_CLIENT_PORT`
- JavaScript — Node inspector paused on the first line, reachable on the host at `NODE_INSPECT_PORT`

Map `/workspace` in the container to the project directory on the host in the IDE path mappings. The generated `<problem-directory>/scripts/debug.sh` links to the IDE setup instructions.

### 9. Generate progressive hints

If stuck, generate a series of progressive hints to guide you through the problem:

```bash
docker exec leetup hints <problem-directory>
```

Example:
```bash
docker exec leetup hints 3-longest-substring-without-repeating-characters-GO
```

The same can be done from the opencode terminal:

```
/leetup-hints <problem-directory>
```

### 10. Review your solution

Get detailed feedback on your completed solution including complexity analysis and optimization suggestions:

```bash
docker exec leetup review <problem-directory>
```

Example:
```bash
docker exec leetup review 1-two-sum-GO
```

The same can be done from the opencode terminal:

```
/leetup-review <problem-directory>
```

## SQL problems

Database problems run on MySQL 8.0 in the `leetup-mysql` container. That's the version LeetCode uses, and like LeetCode, no SQL mode is enabled. There are no tests: you run the query from your IDE or DB client and compare the result with the expected one by eye.

```bash
docker exec leetup setup sql game-play-analysis-i
```

Setup loads LeetCode's schema of the problem (its tables and the rows of the first example) into the database `{id}-{slug}` (cut to 64 characters, the MySQL limit), and prints how to connect:

```
⚡ Database: mysql://root:leetup@localhost:3306/1179-game-play-analysis-i
⚡ JDBC URL: jdbc:mysql://localhost:3306/1179-game-play-analysis-i?user=root&password=leetup
```

The first line works with the `mysql` client and most tools. JetBrains IDEs are Java-based and only accept JDBC URLs (`jdbc:` prefix), so paste the second one into the data source's URL field.

It also creates `solution.sql`, holding the same connection details, the expected output of the first example and the LeetCode snippet:

```sql
-- Database: mysql://root:leetup@localhost:3306/1179-game-play-analysis-i
-- JDBC URL: jdbc:mysql://localhost:3306/1179-game-play-analysis-i?user=root&password=leetup

-- Expected output:
-- +-----------+-------------+
-- | player_id | first_login |
-- +-----------+-------------+
-- | 1         | 2016-03-01  |
-- ...
USE `1179-game-play-analysis-i`;
# Write your MySQL query statement below
```

Other examples are left out; they are still in `problem.md`. The data lives in a Docker volume, so it survives `docker-compose down`. Running setup again reloads the database, which resets the data after an `UPDATE` or `DELETE` solution. `solution.sql` is kept.

`check`, `debug` and `installdeps` are not available for SQL problems. `hints` and `review` work as usual.

## Configuration

Anything that varies from one machine to another lives in `.env`, never in the image or in a committed script. Defaults apply when a value is unset, so `.env` only has to carry what is actually different here.

| Variable | Default | What it is for |
| --- | --- | --- |
| `OPENCODE_PROVIDER_ID` | — | Agent provider, see [models.dev](https://models.dev/) |
| `OPENCODE_MODEL_ID` | — | Model the agents run on |
| `OPENCODE_SMALL_MODEL_ID` | — | Cheaper model, used for test generation |
| `OPENCODE_API_KEY` | — | Provider credentials |
| `LEETCODE_API_PORT` | `3000` | Host port the problem API is published on |
| `DELVE_PORT` | `40000` | Host port the Go debugger is published on |
| `NODE_INSPECT_PORT` | `9229` | Host port the JavaScript debugger is published on |
| `MYSQL_PORT` | `3306` | Host port MySQL is published on, for SQL problems |
| `XDEBUG_CLIENT_HOST` | `host.docker.internal` | Where Xdebug reaches the IDE from inside the container |
| `XDEBUG_CLIENT_PORT` | `9003` | Port the IDE listens for Xdebug on |
| `PHP_IDE_SERVER_NAME` | `leetup` | IDE server entry holding the `/workspace` path mapping |

The ports above are host-side only; the container-side ports are fixed, so changing one does not ripple into the scripts. The Xdebug settings are written by `entrypoint.sh` on container start rather than baked into the image, so changing them needs no rebuild. Run `docker-compose up -d` after editing `.env`: the container environment is fixed at creation time, so compose has to recreate the container for a new value to land (`docker-compose restart` would keep the old one).

On plain Linux, `host.docker.internal` does not resolve by default. Either add

```yaml
extra_hosts:
  - "host.docker.internal:host-gateway"
```

to the `leetup` service, or point `XDEBUG_CLIENT_HOST` at the `docker0` address.

## Requirements

- Docker
- Docker Compose

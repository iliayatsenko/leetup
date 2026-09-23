# LeetUp

A streamlined LeetCode practice environment with automatic problem setup and multi-language support.

## Features

- Fetch LeetCode problems automatically from API
- Generate problem descriptions, hints, and test scaffolding
- Support for several programming languages (Go, PHP)
- Run tests with a single command
- Debug solutions from the IDE with delve (Go) and Xdebug (PHP)

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
```

### 4. Generate unit tests using Claude Code custom command

After setting up a new problem, generate comprehensive unit tests (in Claude Code terminal):

```
/leetup-tests <problem-directory>
```

Example:
```
/leetup-tests 1-two-sum-GO
```

### 5. Implement your solution in the `solution.<lang>` file

### 6. Install dependencies

Declare what the solution needs first — imports in Go, the `require` section of `composer.json` in PHP — then install them:

```bash
docker exec leetup installdeps <problem-directory>
```

Examples:
```bash
docker exec leetup installdeps 1-two-sum-GO
docker exec leetup installdeps 1-two-sum-PHP
```

Go runs `go mod tidy`, syncing `go.mod` and `go.sum` with the imports found in the code. Modules are downloaded into the shared `deps/go/pkg/mod` cache, which is content-addressed, so problems cannot interfere with each other there.

PHP resolves two layers separately:

| Layer | Manifest | Installed into | Command |
| --- | --- | --- | --- |
| Test tooling, shared | `deps/php/composer.json` | `deps/php/vendor` | `composer install`, once |
| The solution's own deps | `<problem-directory>/composer.json` | `<problem-directory>/vendor` | `composer update`, per problem |

Each problem owning its own `vendor` is deliberate: Composer makes a vendor directory match the manifest it was run from *exactly*, removing anything absent from it, so pointing several problems at one shared `vendor` means installing one uninstalls the others' packages. Only PHPUnit is shared, because it is the heavy part — about 10M against a few hundred K for a typical problem dependency — and because it has to sit under `/workspace` for the IDE to resolve its sources while debugging, which is why it is installed here rather than baked into the image.

The tooling uses `composer install` since `deps/php/composer.lock` pins it; a problem uses `composer update`, because `install` refuses to run against a `composer.lock` that a hand-edited `require` section no longer matches. PHPUnit is then run with `--bootstrap vendor/autoload.php` so that the problem's own packages resolve, since the shared PHPUnit's autoloader knows nothing about them.

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

The same can be done from the Claude Code terminal:

```
/leetup-hints <problem-directory>
```

### 10. Review your solution

Get detailed feedback on your completed solution including complexity analysis and optimization suggestions (in Claude Code terminal):

```
/leetup-review <problem-directory>
```

Example:
```
/leetup-review 1-two-sum-GO
```

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
- Claude Code

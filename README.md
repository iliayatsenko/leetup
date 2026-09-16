# LeetUp

A streamlined LeetCode practice environment with automatic problem setup and multi-language support.

## Features

- Fetch LeetCode problems automatically from API
- Generate problem descriptions, hints, and test scaffolding
- Support for several programming languages (Go, PHP)
- Run tests with a single command
- Debug solutions from the IDE with delve (Go) and Xdebug (PHP)

## Usage

### 1. Start the environment

```bash
docker-compose up -d
```

### 2. Setup a new problem

```bash
docker exec leetup setup <language> <problem-slug-or-link>
```

Examples:
```bash
docker exec leetup setup go two-sum
docker exec leetup setup php https://leetcode.com/problems/two-sum/
```

### 3. Generate unit tests using Claude Code custom command

After setting up a new problem, generate comprehensive unit tests (in Claude Code terminal):

```
/leetup-tests <problem-directory>
```

Example:
```
/leetup-tests 1-two-sum-GO
```

### 4. Implement your solution in the `solution.<lang>` file

### 5. Run tests

```bash
docker exec leetup check <problem-directory>
```

Example:
```bash
docker exec leetup check 1-two-sum-GO
```

### 6. Debug your solution

```bash
docker exec leetup debug <problem-directory>
```

Example:
```bash
docker exec leetup debug 1-two-sum-GO
```

The command starts a debug session running the tests and waits for the IDE to attach:

- Go — headless delve session listening on port `40000`
- PHP — Xdebug connecting out to the IDE listener on port `9003`

Map `/workspace` in the container to the project directory on the host in the IDE path mappings. The generated `<problem-directory>/scripts/debug.sh` links to the IDE setup instructions.

### 7. Generate progressive hints

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

### 8. Review your solution

Get detailed feedback on your completed solution including complexity analysis and optimization suggestions (in Claude Code terminal):

```
/leetup-review <problem-directory>
```

Example:
```
/leetup-review 1-two-sum-GO
```

## Requirements

- Docker
- Docker Compose
- Claude Code

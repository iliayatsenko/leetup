# LeetUp

A streamlined LeetCode practice environment with automatic problem setup and multi-language support.

## Features

- Fetch LeetCode problems automatically from API
- Generate problem descriptions, hints, and test scaffolding
- Support for several programming languages (Go, PHP)
- Run tests with a single command

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

### 6. Generate progressive hints

If stuck, generate a series of progressive hints to guide you through the problem (in Claude Code terminal):

```
/leetup-hints <problem-directory>
```

Example:
```
/leetup-hints 3-longest-substring-without-repeating-characters-GO
```

### 7. Review your solution

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

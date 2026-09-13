# leetup

LeetCode solutions in Go.

## Structure

Each problem lives in its own directory: `{number}-{problem-name}-GO/`
- `solution.go` — implementation (`package solution`)
- `solution_test.go` — tests

No root `go.mod`. Each directory is a standalone Go package.

## Commands

```bash
# Run tests for a specific problem
cd 1-two-sum-GO && go test ./...

# Run tests verbosely
cd 1-two-sum-GO && go test -v ./...
```

## Workflow

- Work on the `solutions` branch
- Add new problems by creating a new directory following the naming convention
- Each solution must have a corresponding `solution_test.go`

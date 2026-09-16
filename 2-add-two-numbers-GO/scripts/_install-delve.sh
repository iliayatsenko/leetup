#!/bin/bash

# Check if delve is installed
if ! command -v ~/go/bin/dlv &> /dev/null; then
  go install github.com/go-delve/delve/cmd/dlv@latest
fi

# Write delve configuration, mapping container paths to host ones
cat > ~/.config/dlv/config.yml <<'DELVE_EOF'
substitute-path:
  - {from: /workspace, to: /Users/ilyayatsenko/my/leetup}
DELVE_EOF

#!/bin/bash

# Container entrypoint, run on container start when HOST_PROJECT_PATH is known

# Write delve configuration, mapping container paths to host ones, so that the
# IDE resolves sources during a debug session
if [ -n "$HOST_PROJECT_PATH" ]; then
    mkdir -p ~/.config/dlv
    cat > ~/.config/dlv/config.yml <<DELVE_EOF
substitute-path:
  - {from: /workspace, to: $HOST_PROJECT_PATH}
DELVE_EOF
fi

# Run the container command
exec "$@"

#!/bin/bash

# Check if Go is installed
if ! command -v go &> /dev/null; then
    echo "Go is not installed in leetup container. Installing..."

    apk add --no-cache go

    # Verify installation
    if ! command -v go &> /dev/null; then
        echo "Go installation failed."
        exit 1
    fi

    echo "Go installed successfully: $(go version)"
fi

# Run Go tests with verbose output
go test -v ./...

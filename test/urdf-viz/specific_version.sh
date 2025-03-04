#!/bin/bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
check "urdf-viz binary exists" bash -c "which urdf-viz"
check "urdf-viz runs" bash -c "urdf-viz --help | grep 'Options:'"
check "specific version" bash -c "urdf-viz --version | grep 'v0.7.0'"

# Report result
reportResults

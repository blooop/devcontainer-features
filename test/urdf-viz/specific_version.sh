#!/bin/bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
check "urdf-viz binary exists" bash -c "which urdf-viz"
check "urdf-viz version command" bash -c "urdf-viz --version"
check "specific version" bash -c "urdf-viz --version | grep 'v0.46.1'"

# Report result
reportResults

#!/bin/bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
check "urdf-viz binary exists" bash -c "which urdf-viz"
check "urdf-viz version command" bash -c "urdf-viz --version"
check "urdf-viz help command" bash -c "urdf-viz --help | grep -E 'Usage|Options'"

# Report result
reportResults

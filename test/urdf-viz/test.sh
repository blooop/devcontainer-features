#!/bin/bash

# This test file will be executed against an auto-generated devcontainer.json that
# includes the 'urdf-viz' feature with no options.
#
# For more information, see: https://github.com/devcontainers/cli/blob/main/docs/features/test.md
#
# Syntax: ./test.sh 

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
check "urdf-viz binary exists" bash -c "which urdf-viz"
check "urdf-viz version" bash -c "urdf-viz --version"
check "urdf-viz help" bash -c "urdf-viz --help | wc -l | test \$(cat) -gt 5"

# Report result
reportResults

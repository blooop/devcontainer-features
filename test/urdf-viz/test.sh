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
check "urdf-viz runs" bash -c "urdf-viz --help | grep 'Options:'"
check "version info" bash -c "urdf-viz --version | grep 'urdf-viz'"

# Report result
reportResults

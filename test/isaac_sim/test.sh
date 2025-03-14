#!/bin/bash

# This test file will be executed against an auto-generated devcontainer.json that
# includes the 'isaac_sim' feature with no options.
#
# For more information, see: https://github.com/devcontainers/cli/blob/main/docs/features/test.md
#
# Syntax: ./test.sh 

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
check "isaac sim directory exists" bash -c "test -d /opt/isaac-sim"
check "isaac sim python.sh exists" bash -c "test -f /opt/isaac-sim/python.sh"
check "isaac sim environment variable" bash -c "echo $ISAAC_SIM_PATH | grep /opt/isaac-sim"
check "isaac sim python import" bash -c "/opt/isaac-sim/python.sh -c 'import omni'"
check "isaac sim python path" bash -c "/opt/isaac-sim/python.sh -c 'import sys; print(sys.path)'"

# Report result
reportResults 
#!/bin/bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

echo -e "Checking if urdf-viz is installed:\n"
urdf-viz --version
echo -e "\n"

# Feature-specific tests
check "check urdf-viz is installed" bash -c "which urdf-viz"
check "check urdf-viz version command works" bash -c "urdf-viz --version"

# Report result
reportResults

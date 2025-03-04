#!/bin/bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

echo -e "The result of the 'color' command will be:\n"
color
echo -e "Checking if urdf-viz is installed:\n"
urdf-viz --version
echo -e "\n"

# Feature-specific tests
check "check green is my favorite color" bash -c "color | grep 'my favorite color is green'"
check "check urdf-viz is installed" bash -c "which urdf-viz"
check "check urdf-viz runs" bash -c "urdf-viz --help | grep 'Options:'"

# Report result
reportResults

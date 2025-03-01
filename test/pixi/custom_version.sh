#!/bin/bash

# This test file will be executed against the custom_version scenario
# which includes the 'pixi' feature with version: "v0.40.0"

set -e

# Optional: Import test library
source dev-container-features-test-lib

# Feature-specific tests
check "pixi installed" bash -c "pixi --version"
check "correct version installed" bash -c "pixi --version | grep '0.40.0'"

# Report results
reportResults

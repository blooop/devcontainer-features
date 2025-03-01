#!/bin/bash

# This test file will be executed against the no_bash_completion scenario
# which includes the 'pixi' feature with addBashCompletion: false

set -e

# Optional: Import test library
source dev-container-features-test-lib

# Feature-specific tests
check "pixi installed" bash -c "pixi --version"
check "bash completion not in root bashrc" bash -c "! grep 'pixi completion' /root/.bashrc"

# Note: We can't easily test if it's not in the non-root user's bashrc
# since the tests are run as root by default

# Report results
reportResults

#!/bin/bash

# This test file will be executed against the no_auto_install scenario
# which includes the 'pixi' feature with autoInstallDeps: false

set -e

# Optional: Import test library
source dev-container-features-test-lib

# Feature-specific tests
check "pixi installed" bash -c "pixi --version"
check "post-create script exists" bash -c "test -f /usr/local/devcontainer-features/pixi/post-create.sh"
check "auto install disabled in env" bash -c "grep 'AUTO_INSTALL_DEPS=false' /usr/local/devcontainer-features/pixi/devcontainer-feature.env"

# Report results
reportResults

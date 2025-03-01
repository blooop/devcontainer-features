#!/bin/bash

# This test file will be executed against an auto-generated devcontainer.json that
# includes the 'pixi' Feature with no options.
#
# For the 'pixi' feature, that means using the default version and settings.
#
# This test can be run with the following command:
#
#    devcontainer features test \
#                   --features pixi \
#                   --remote-user root \
#                   --skip-scenarios \
#                   --base-image mcr.microsoft.com/devcontainers/base:ubuntu \
#                   /path/to/this/repo

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
check "pixi installed" bash -c "pixi --version"
check "pixi info runs" bash -c "pixi info"
check "post-create script exists" bash -c "test -f /usr/local/devcontainer-features/pixi/post-create.sh"

# Report results
reportResults

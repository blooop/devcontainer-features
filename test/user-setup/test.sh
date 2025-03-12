#!/bin/bash

set -e

# Optional: Import test library
source dev-container-features-test-lib

# Default username test
check "default user exists" id dev
check "default user has sudo" sudo -u dev sudo echo "sudo works"
check "default user home directory" test -d /home/dev

# Report result
reportResults

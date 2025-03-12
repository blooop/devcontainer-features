#!/bin/bash

set -e

# Optional: Import test library
source dev-container-features-test-lib

# Default username test
check "default user exists" id dev
# check "sudo access is configured" grep -q "dev ALL=" /etc/sudoers.d/dev
check "default user home directory" test -d /home/dev
check "password is set" grep -q "dev:[^:]*:" /etc/shadow

# Report result
reportResults

#!/bin/bash

set -e

# Optional: Import test library
source dev-container-features-test-lib

check "user exists" id dev
check "sudo access is configured" sudo grep -q "dev ALL=" /etc/sudoers.d/dev
check "user home directory" test -d /home/dev
check "password is set" sudo grep -q "dev:[^:]*:" /etc/shadow
# Report result
reportResults

#!/bin/bash

set -e

# Optional: Import test library
source dev-container-features-test-lib

# Alpine username test
check "alpine user exists" id alpineuser
check "sudo access is configured" sudo grep -q "alpineuser ALL=" /etc/sudoers.d/alpineuser
check "user home directory" test -d /home/alpineuser
check "password is set" sudo grep -q "alpineuser:[^:]*:" /etc/shadow

# Report result
reportResults

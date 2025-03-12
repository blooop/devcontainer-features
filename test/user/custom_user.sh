#!/bin/bash

set -e

# Optional: Import test library
source dev-container-features-test-lib

# Custom username test
check "custom user exists" id devuser
check "passwordless sudo is configured" grep -q "devuser ALL=(ALL) NOPASSWD: ALL" /etc/sudoers.d/devuser
check "custom user home directory" test -d /home/devuser
check "password is set" grep -q "devuser:[^:]*:" /etc/shadow

# Test that sudo doesn't require password
check "sudo without password works" sudo -n echo "sudo works without password"

# Report result
reportResults

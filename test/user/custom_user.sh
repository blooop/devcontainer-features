#!/bin/bash

set -e

# Optional: Import test library
source dev-container-features-test-lib

# Custom username test
check "custom user exists" id devuser
check "sudo access is configured" sudo grep -q "devuser ALL=" /etc/sudoers.d/devuser
check "custom user home directory" test -d /home/devuser
check "password is set" sudo grep -q "devuser:[^:]*:" /etc/shadow

# Report result
reportResults

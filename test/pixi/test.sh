#!/bin/bash

set -e

source dev-container-features-test-lib

check "pixi is the default version" bash -c "pixi --version | grep -qx 'pixi 0.83.0'"
check "bash completion loads" bash -ic "complete -p pixi"
check "post-create hook is installed" test -x /usr/local/devcontainer-features/pixi/post-create.sh

reportResults

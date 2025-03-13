#!/bin/bash
set -e

echo "Activating feature 'urdf-viz'"

# Source the helper script
. ./library_script.sh

VERSION=${VERSION:-"latest"}
echo "The requested version is: ${VERSION}"

# Install dependencies
apt-get update && apt-get install -y libxcb1 libx11-6 libgl1 libxau6 libxdmcp6

# nanolayer is a cli utility which keeps container layers as small as possible
# source code: https://github.com/devcontainers-extra/nanolayer
# `ensure_nanolayer` is a bash function that will find any existing nanolayer installations,
# and if missing - will download a temporary copy that automatically get deleted at the end
# of the script
ensure_nanolayer nanolayer_location "v0.5.4"

# Use nanolayer to install the gh-release feature, which will handle the GitHub release download
echo "Installing urdf-viz version ${VERSION}..."
$nanolayer_location \
    install \
    devcontainer-feature \
    "ghcr.io/devcontainers-extra/features/gh-release:1.0.25" \
    --option repo='openrr/urdf-viz' \
    --option binaryNames='urdf-viz' \
    --option version="${VERSION}" \
    --option assetRegex="urdf-viz-x86_64-unknown-linux-gnu.tar.gz" \
    --option binPath="/usr/local/bin" \
    --option dirPath="/tmp/urdf-viz" \
    --option strip=1

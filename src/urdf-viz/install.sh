#!/bin/bash
set -e

echo "Activating feature 'urdf-viz'"

VERSION=${VERSION:-"latest"}
echo "The requested version is: ${VERSION}"

# Install dependencies
apt-get update && apt-get install -y libxcb1 libx11-6 libgl1 libxau6 libxdmcp6

# Install nanolayer if not already installed
if ! command -v nanolayer &> /dev/null; then
    echo "Installing nanolayer..."
    curl -fsSL https://github.com/devcontainers/features/releases/download/v1.1.22/install-nanolayer.sh | bash
fi

# Use nanolayer to download and install urdf-viz from GitHub releases
if [ "${VERSION}" = "latest" ]; then
    echo "Installing latest version of urdf-viz..."
    nanolayer install \
        --type github-release \
        --repo openrr/urdf-viz \
        --match-asset "urdf-viz-x86_64-unknown-linux-gnu.tar.gz" \
        --target /tmp/urdf-viz.tar.gz
else
    echo "Installing urdf-viz version ${VERSION}..."
    nanolayer install \
        --type github-release \
        --repo openrr/urdf-viz \
        --tag "${VERSION}" \
        --match-asset "urdf-viz-x86_64-unknown-linux-gnu.tar.gz" \
        --target /tmp/urdf-viz.tar.gz
fi

# Extract and install
mkdir -p /tmp/urdf-viz
tar -xzf /tmp/urdf-viz.tar.gz -C /tmp/urdf-viz
find /tmp/urdf-viz -name urdf-viz -type f -exec cp {} /usr/local/bin/ \;
chmod +x /usr/local/bin/urdf-viz

# Clean up
rm -rf /tmp/urdf-viz /tmp/urdf-viz.tar.gz

# Verify installation
if command -v urdf-viz &> /dev/null; then
    echo "urdf-viz installation complete. You can now run 'urdf-viz' to visualize URDF files."
    urdf-viz --version
else
    echo "Error: urdf-viz installation failed."
    exit 1
fi

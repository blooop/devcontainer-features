#!/bin/sh
set -e

echo "Activating feature 'urdf-viz'"

VERSION=${VERSION:-"latest"}
echo "The requested version is: ${VERSION}"

# Install dependencies
apt-get update && apt-get install -y --no-install-recommends \
    jq \
    curl \ 
    libxi6 \
    libxcursor-dev \
    libxrandr-dev \

if [ "${VERSION}" = "latest" ]; then
    echo "Installing latest version of urdf-viz..."
    DOWNLOAD_URL=$(curl -sL https://api.github.com/repos/openrr/urdf-viz/releases/latest | \
        jq -r '.assets[] | select(.name == "urdf-viz-x86_64-unknown-linux-gnu.tar.gz") | .browser_download_url')
else
    echo "Installing urdf-viz version ${VERSION}..."
    DOWNLOAD_URL=$(curl -sL https://api.github.com/repos/openrr/urdf-viz/releases/tags/${VERSION} | \
        jq -r '.assets[] | select(.name == "urdf-viz-x86_64-unknown-linux-gnu.tar.gz") | .browser_download_url')
    
    if [ -z "$DOWNLOAD_URL" ] || [ "$DOWNLOAD_URL" = "null" ]; then
        echo "Error: Could not find urdf-viz version ${VERSION}"
        exit 1
    fi
fi

echo "Downloading from: ${DOWNLOAD_URL}"
curl -sL "${DOWNLOAD_URL}" -o urdf-viz.tar.gz

# Extract and install
mkdir -p /tmp/urdf-viz
tar -xzf urdf-viz.tar.gz -C /tmp/urdf-viz
find /tmp/urdf-viz -name urdf-viz -type f -exec cp {} /usr/local/bin/ \;
chmod +x /usr/local/bin/urdf-viz

# Clean up
rm -rf /tmp/urdf-viz urdf-viz.tar.gz

echo "urdf-viz installation complete. You can now run 'urdf-viz' to visualize URDF files."

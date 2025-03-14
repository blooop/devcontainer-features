#!/bin/bash

set -e

# Get the version from the feature options
VERSION="${VERSION:-2024.1.0}"

# Install required dependencies
apt-get update
apt-get install -y curl unzip

# Download URL for Isaac Sim
DOWNLOAD_URL="https://download.isaacsim.omniverse.nvidia.com/isaac-sim-standalone%404.5.0-rc.36%2Brelease.19112.f59b3005.gl.linux-x86_64.release.zip"

# Create installation directory
INSTALL_DIR="/opt/isaac-sim"
mkdir -p "${INSTALL_DIR}"

# Use nanolayer's cache directory
CACHE_DIR="${NANOLAYER_CACHE_DIR:-/tmp/nanolayer/cache}"
mkdir -p ${CACHE_DIR}

# Cache key for the download
CACHE_KEY="isaac-sim-${VERSION}"
CACHED_FILE="${CACHE_DIR}/${CACHE_KEY}.zip"

# Download and extract Isaac Sim
if [ ! -f "${CACHED_FILE}" ]; then
    echo "Downloading Isaac Sim..."
    curl -L "${DOWNLOAD_URL}" -o "${CACHED_FILE}"
else
    echo "Using cached Isaac Sim download..."
fi

echo "Extracting Isaac Sim..."
unzip -q -o ${CACHED_FILE} -d ${INSTALL_DIR}

# Set permissions
chown -R ${USER}:${USER} ${INSTALL_DIR}

# Add Isaac Sim to PATH
echo "export ISAAC_SIM_PATH=${INSTALL_DIR}" >> ~/.bashrc
echo "export PATH=\${ISAAC_SIM_PATH}/python.sh:\$PATH" >> ~/.bashrc

# Test Isaac Sim installation
echo "Testing Isaac Sim installation..."
${INSTALL_DIR}/python.sh -c "import omni; print('Isaac Sim installation successful!')" 
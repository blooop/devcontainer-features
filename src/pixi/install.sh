#!/bin/bash
set -e

# The 'install.sh' entrypoint script is always executed as the root user.
#
# These variables are available:
# - PIXI_VERSION: The requested version (default: v0.41.4)
# - ADD_BASH_COMPLETION: Whether to add bash completion (true/false)
# - AUTO_INSTALL_DEPS: Whether to auto-run pixi install (true/false)
# - CONFIGURE_VOLUME: Whether to add volume configuration to devcontainer (true/false)
# - _REMOTE_USER: The user name of the non-root user in the container
# - _REMOTE_USER_HOME: The home directory of the non-root user

PIXI_VERSION="${VERSION:-"v0.41.4"}"
ADD_BASH_COMPLETION="${ADDBASHCOMPLETION:-"true"}"
AUTO_INSTALL_DEPS="${AUTOINSTALLDEPS:-"true"}"
CONFIGURE_VOLUME="${CONFIGUREVOLUME:-"true"}"

echo "Setting up Pixi ${PIXI_VERSION}..."

# Ensure curl is installed
if ! type curl > /dev/null 2>&1; then
    echo "Installing curl..."
    apt-get update -y
    apt-get install -y curl
fi

# Install Pixi
curl -L -o /usr/local/bin/pixi -fsSL --compressed "https://github.com/prefix-dev/pixi/releases/download/${PIXI_VERSION}/pixi-$(uname -m)-unknown-linux-musl"
chmod +x /usr/local/bin/pixi
pixi info

# Add bash completion if requested
if [ "${ADD_BASH_COMPLETION}" = "true" ]; then
    echo "Adding Pixi bash completion..."
    if [ ! -z "${_REMOTE_USER}" ]; then
        echo "eval \"$(pixi completion -s bash)\"" >> "${_REMOTE_USER_HOME}/.bashrc"
    fi
fi

# Create a hook script for the post create command if auto install is enabled
if [ "${AUTO_INSTALL_DEPS}" = "true" ] || [ "${CONFIGURE_VOLUME}" = "true" ]; then
    DEVCONTAINER_FEATURES_PATH="/usr/local/devcontainer-features"
    mkdir -p "${DEVCONTAINER_FEATURES_PATH}/pixi"
    
    cat > "${DEVCONTAINER_FEATURES_PATH}/pixi/post-create.sh" << 'EOF'
#!/bin/bash
set -e

echo "Running Pixi post-create setup..."

# Ensure proper ownership of the .pixi directory
if [ -d ".pixi" ]; then
    echo "Setting permissions on .pixi directory..."
    sudo chown -R $(whoami) .pixi
fi

# Run pixi install if enabled
if [ "${AUTO_INSTALL_DEPS}" = "true" ] && [ -f "pixi.toml" ]; then
    echo "Installing Pixi dependencies..."
    pixi install
fi
EOF
    chmod +x "${DEVCONTAINER_FEATURES_PATH}/pixi/post-create.sh"
    
    # Generate feature configuration for devcontainer.json
    cat > "${DEVCONTAINER_FEATURES_PATH}/pixi/devcontainer-feature.env" << EOF
AUTO_INSTALL_DEPS=${AUTO_INSTALL_DEPS}
EOF
fi

# Provide usage hint
cat << EOF
🎉 Pixi installation complete!

Usage:
   To use this feature in your devcontainer.json:
   
   "features": {
     "ghcr.io/your-org/devcontainer-features/pixi:1": {
       "version": "${PIXI_VERSION}"
     }
   }
EOF

if [ "${CONFIGURE_VOLUME}" = "true" ]; then
    cat << EOF
   
   Add this to your devcontainer.json to persist Pixi packages:
   "mounts": ["source=\${localWorkspaceFolderBasename}-pixi,target=\${containerWorkspaceFolder}/.pixi,type=volume"]
EOF
fi

if [ "${AUTO_INSTALL_DEPS}" = "true" ]; then
    cat << EOF
   
   Add this to your devcontainer.json to run Pixi installation:
   "postCreateCommand": "bash /usr/local/devcontainer-features/pixi/post-create.sh"
EOF
fi

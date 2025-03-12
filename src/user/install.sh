#!/bin/bash
set -e

# Get arguments
USERNAME="${USERNAME:-"dev"}"
USER_UID="${USERUID:-"1000"}"
USER_GID="${USERGID:-"1000"}"
USER_SHELL="${USERSHELL:-"/bin/bash"}"
INSTALL_SUDO="${INSTALLSUDO:-"true"}"
CREATE_HOME_DIR="${CREATEHOMEDIR:-"true"}"
ADDITIONAL_GROUPS="${ADDITIONALGROUPS:-""}"

echo "Setting up user '${USERNAME}' with UID ${USER_UID} and GID ${USER_GID}"

# Determine OS version and package manager
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS_ID=$ID
else
    OS_ID=$(uname -s)
fi

# Install sudo if not available
if [ "$INSTALL_SUDO" = "true" ] && ! command -v sudo >/dev/null 2>&1; then
    echo "Installing sudo..."
    case "$OS_ID" in
        debian|ubuntu)
            apt-get update
            apt-get install -y sudo
            ;;
        alpine)
            apk add --no-cache sudo
            ;;
        centos|fedora|rhel)
            if command -v dnf >/dev/null 2>&1; then
                dnf install -y sudo
            else
                yum install -y sudo
            fi
            ;;
        *)
            echo "WARNING: Unsupported OS for sudo installation. Please install sudo manually."
            ;;
    esac
fi

# Create group if it doesn't exist
if ! getent group "$USER_GID" >/dev/null 2>&1; then
    echo "Creating group with GID ${USER_GID}..."
    groupadd -g "$USER_GID" "$USERNAME"
fi

# Get group name from GID
GROUP_NAME=$(getent group "$USER_GID" | cut -d: -f1)
if [ -z "$GROUP_NAME" ]; then
    GROUP_NAME="$USERNAME"
    groupadd -g "$USER_GID" "$GROUP_NAME"
fi

# Create user if it doesn't exist
if ! id -u "$USERNAME" >/dev/null 2>&1; then
    echo "Creating user ${USERNAME}..."
    if [ "$CREATE_HOME_DIR" = "true" ]; then
        useradd -m -s "$USER_SHELL" -u "$USER_UID" -g "$USER_GID" "$USERNAME"
    else
        useradd -M -s "$USER_SHELL" -u "$USER_UID" -g "$USER_GID" "$USERNAME"
    fi
fi

# Add user to additional groups if specified
if [ -n "$ADDITIONAL_GROUPS" ]; then
    echo "Adding user to additional groups: $ADDITIONAL_GROUPS"
    IFS=',' read -ra GROUPS <<< "$ADDITIONAL_GROUPS"
    for GROUP in "${GROUPS[@]}"; do
        # Check if group exists, create if not
        if ! getent group "$GROUP" >/dev/null 2>&1; then
            groupadd "$GROUP"
        fi
        usermod -aG "$GROUP" "$USERNAME"
    done
fi

# Setup sudo access
if command -v sudo >/dev/null 2>&1; then
    echo "Configuring sudo access..."
    # Create sudoers.d directory if it doesn't exist
    mkdir -p /etc/sudoers.d
    
    # Always set up passwordless sudo for simplicity in development containers
    echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/$USERNAME"
    chmod 440 "/etc/sudoers.d/$USERNAME"
fi

# Create home directory if it doesn't exist and is requested
if [ "$CREATE_HOME_DIR" = "true" ] && [ ! -d "/home/$USERNAME" ]; then
    echo "Creating home directory /home/$USERNAME..."
    mkdir -p "/home/$USERNAME"
    chown "$USER_UID:$USER_GID" "/home/$USERNAME"
    chmod 755 "/home/$USERNAME"
fi

# Basic setup of bash configuration if shell is bash and home exists
if [ "$USER_SHELL" = "/bin/bash" ] && [ -d "/home/$USERNAME" ]; then
    if [ ! -f "/home/$USERNAME/.bashrc" ]; then
        cp /etc/skel/.bashrc "/home/$USERNAME/.bashrc" 2>/dev/null || echo "# .bashrc" > "/home/$USERNAME/.bashrc"
        chown "$USER_UID:$USER_GID" "/home/$USERNAME/.bashrc"
    fi
    
    if [ ! -f "/home/$USERNAME/.profile" ]; then
        cp /etc/skel/.profile "/home/$USERNAME/.profile" 2>/dev/null || echo "# .profile" > "/home/$USERNAME/.profile"
        chown "$USER_UID:$USER_GID" "/home/$USERNAME/.profile"
    fi
fi

echo "User $USERNAME setup complete!"
#!/bin/bash
set -e
set -o pipefail

# Get arguments
USERNAME="${USERNAME:-"dev"}"
USER_UID="${USERUID:-"1000"}"
USER_GID="${USERGID:-"1000"}"
USER_SHELL="${USERSHELL:-"/bin/bash"}"
USER_PASSWORD="${PASSWORD:-"password"}"
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

# Check if this is a Debian-based distribution
if [[ "$OS_ID" != "debian" && "$OS_ID" != "ubuntu" ]]; then
    echo "ERROR: This feature only supports Debian-based distributions (debian, ubuntu)."
    echo "Detected OS: $OS_ID"
    exit 1
fi

# Install sudo and passwd if not available
if [ "$INSTALL_SUDO" = "true" ] && ! command -v sudo >/dev/null 2>&1; then
    echo "Installing sudo..."
    apt-get update
    apt-get install -y sudo passwd
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

# Check if a user with the specified UID already exists
EXISTING_USER=$(getent passwd "$USER_UID" | cut -d: -f1 || echo "")

# Create user or modify existing user with the specified UID
if [ -z "$EXISTING_USER" ]; then
    # No user with this UID exists, create a new one
    echo "Creating user ${USERNAME}..."
    if [ "$CREATE_HOME_DIR" = "true" ]; then
        useradd -m -s "$USER_SHELL" -u "$USER_UID" -g "$USER_GID" "$USERNAME"
    else
        useradd -M -s "$USER_SHELL" -u "$USER_UID" -g "$USER_GID" "$USERNAME"
    fi
    
    # Set user password
    echo "${USERNAME}:${USER_PASSWORD}" | chpasswd
    echo "Password set for ${USERNAME}"
elif [ "$EXISTING_USER" != "$USERNAME" ]; then
    # A user with this UID exists but with a different name
    echo "User with UID ${USER_UID} already exists as '${EXISTING_USER}'"
    echo "Using next available UID for user '${USERNAME}'..."
    
    if [ "$CREATE_HOME_DIR" = "true" ]; then
        useradd -m -s "$USER_SHELL" -g "$USER_GID" "$USERNAME"
    else
        useradd -M -s "$USER_SHELL" -g "$USER_GID" "$USERNAME"
    fi
    
    # Set user password
    echo "${USERNAME}:${USER_PASSWORD}" | chpasswd
    echo "Password set for ${USERNAME}"
    
    # Update USER_UID to the actual UID assigned
    USER_UID=$(id -u "$USERNAME")
    echo "Assigned UID ${USER_UID} to user ${USERNAME}"
else
    # User with this name and UID already exists
    echo "User ${USERNAME} already exists with UID ${USER_UID}"
    
    # Update shell if different
    current_shell=$(getent passwd "$USERNAME" | cut -d: -f7)
    if [ "$current_shell" != "$USER_SHELL" ]; then
        usermod -s "$USER_SHELL" "$USERNAME"
        echo "Updated shell to $USER_SHELL"
    fi
    
    # Update primary group if different
    current_gid=$(id -g "$USERNAME")
    if [ "$current_gid" != "$USER_GID" ]; then
        usermod -g "$USER_GID" "$USERNAME"
        echo "Updated primary group to GID $USER_GID"
    fi
    
    # Set user password
    echo "${USERNAME}:${USER_PASSWORD}" | chpasswd
    echo "Password updated for ${USERNAME}"
    
    # Create home directory if it doesn't exist and is requested
    if [ "$CREATE_HOME_DIR" = "true" ] && [ ! -d "/home/$USERNAME" ]; then
        echo "Creating home directory /home/$USERNAME..."
        mkdir -p "/home/$USERNAME"
        chown "$USER_UID:$USER_GID" "/home/$USERNAME"
        chmod 755 "/home/$USERNAME"
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
    
    echo "$USERNAME ALL=(ALL) ALL" > "/etc/sudoers.d/$USERNAME"
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
echo "Note: The user will be prompted for password when using sudo."
echo "The password is: ${USER_PASSWORD}"
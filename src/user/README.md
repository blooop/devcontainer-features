# User (user)

This feature creates a non-root user with sudo permissions in any container. It's particularly useful for containers that only have the root user configured by default.

## Example Usage

```json
"features": {
    "ghcr.io/blooop/devcontainer-features/user:1": {
        "username": "dev",
        "password": "mypassword"
    }
}
```

## Options

| Option ID | Description | Type | Default Value |
|-----|-----|-----|-----|
| username | Username for the non-root user | string | dev |
| userUid | User ID (UID) for the non-root user | string | 1000 |
| userGid | Group ID (GID) for the non-root user | string | 1000 |
| userShell | Default shell for the non-root user | string | /bin/bash |
| password | Password for the non-root user (required for sudo) | string | password |
| passwordlessSudo | Allow sudo commands without password prompt | boolean | false |
| installSudo | Install sudo if not already available | boolean | true |
| createHomeDir | Create home directory for the user | boolean | true |
| additionalGroups | Comma-separated list of additional groups for the user | string | |

## Using with remoteUser

To use the created user as the remote user in your devcontainer, add the following to your `devcontainer.json`:

```json
"remoteUser": "dev"
```

Make sure the username matches the one you configured in the feature.

## Compatibility

This feature is designed to work with most Linux distributions that support the standard user management commands and sudo. This includes:
- Debian/Ubuntu
- Alpine
- CentOS/RHEL/Fedora

## Notes

- The feature will attempt to install sudo if it's not already available in the container
- By default, the user must enter a password when using sudo
- If you need passwordless sudo, set `passwordlessSudo` to true
- The default password is "password" if not specified
- The user's home directory will be created at `/home/username` if `createHomeDir` is true
- You can add the user to additional groups by providing a comma-separated list to `additionalGroups`

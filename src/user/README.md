
# User (user)

Create a non-root user with sudo permissions in any container

## Example Usage

```json
"features": {
    "ghcr.io/blooop/devcontainer-features/user:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| username | Username for the non-root user | string | dev |
| userUid | User ID (UID) for the non-root user | string | 1000 |
| userGid | Group ID (GID) for the non-root user | string | 1000 |
| userShell | Default shell for the non-root user | string | /bin/bash |
| password | Password for the non-root user (required for sudo) | string | password |
| installSudo | Install sudo if not already available | boolean | true |
| createHomeDir | Create home directory for the user | boolean | true |
| additionalGroups | Comma-separated list of additional groups for the user | string | - |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/blooop/devcontainer-features/blob/main/src/user/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._

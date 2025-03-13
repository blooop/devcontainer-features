# Dev Container Features

This repository contains a collection of [dev container Features](https://containers.dev/implementors/features/) that can be added to your development containers.

## Available Features

### `urdf-viz`

Installs urdf-viz, a visualization tool for URDF (Unified Robot Description Format).

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/blooop/devcontainer-features/urdf-viz:1": {}
    }
}
```

### `pixi`

Install and configure Pixi package manager for Python project dependencies.

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/blooop/devcontainer-features/pixi:0": {
            "version": "v0.41.4",
            "addBashCompletion": true,
            "autoInstallDeps": true
        }
    }
}
```

### `user`

Create a non-root user with sudo permissions in containers, particularly useful for containers that only have the root user configured by default.

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/blooop/devcontainer-features/user:1": {
            "username": "dev",
            "password": "password"
        }
    },
    "remoteUser": "dev"
}
```

## Feature Details

Each feature includes:
- Installation script with configurable options
- Documentation in the feature's README.md
- Tests to ensure functionality across different environments

For more information about each feature and available options, see the README in each feature's directory in the `src` folder.

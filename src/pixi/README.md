# Pixi Package Manager (pixi)

This feature installs the [Pixi package manager](https://github.com/prefix-dev/pixi) for Python project dependencies.

## Example Usage

```json
"features": {
    "ghcr.io/blooop/devcontainer-features/pixi:1": {
        "version": "v0.41.4"
    }
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Version of Pixi to install | string | v0.41.4 |
| addBashCompletion | Add Pixi bash completion | boolean | true |
| autoInstallDeps | Automatically run 'pixi install' during container creation | boolean | true |
| configureVolume | Configure a named volume for .pixi directory | boolean | true |

## Using the Feature

With default options, this feature will:

1. Install Pixi package manager
2. Add bash completion for Pixi
3. Setup automatic dependency installation
4. Suggest volume configuration for .pixi directory

To complete the setup, add the following to your devcontainer.json:

```json
"mounts": [
    "source=${localWorkspaceFolderBasename}-pixi,target=${containerWorkspaceFolder}/.pixi,type=volume"
],
"postCreateCommand": "bash /usr/local/devcontainer-features/pixi/post-create.sh"
```

This will ensure your Pixi packages are persisted between container rebuilds and are automatically installed on container startup.

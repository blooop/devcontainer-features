
# Pixi Package Manager (pixi)

Install and configure Pixi package manager for Python project dependencies

## Example Usage

```json
"features": {
    "ghcr.io/blooop/devcontainer-features/pixi:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Pixi version to install | string | v0.41.4 |
| addBashCompletion | Add Pixi bash completion | boolean | true |
| autoInstallDeps | Automatically run 'pixi install' during container creation | boolean | true |
| configureVolume | Configure a named volume for .pixi directory | boolean | true |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/blooop/devcontainer-features/blob/main/src/pixi/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._

# URDF Visualizer (urdf-viz)

This feature installs [urdf-viz](https://github.com/openrr/urdf-viz), a visualization tool for URDF (Unified Robot Description Format) files.

## Example Usage

```json
"features": {
    "ghcr.io/your-username/devcontainer-features/urdf-viz:1": {
        "version": "latest"
    }
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Version of urdf-viz to install. Use 'latest' for the most recent release. | string | latest |

## Using urdf-viz

After the container is built, you can use `urdf-viz` from the terminal to visualize URDF files:

```bash
# Visualize a URDF file
urdf-viz path/to/your/robot.urdf
```

## Requirements

This feature automatically installs the required dependencies:
- jq
- curl

For X11 forwarding to display the visualization GUI, you'll need to configure your devcontainer for GUI applications.

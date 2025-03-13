# Isaac Sim DevContainer Feature

This feature installs NVIDIA Isaac Sim in the devcontainer environment.

## Features

- Installs Isaac Sim 2024.1.0
- Sets up environment variables and PATH
- Includes Python support
- Automatically tests the installation

## Usage

Add the following to your devcontainer.json:

```json
{
    "features": {
        "ghcr.io/devcontainers/features/isaac_sim:1": {
            "version": "2024.1.0",
            "installPython": true
        }
    }
}
```

## Environment Variables

- `ISAAC_SIM_PATH`: Path to Isaac Sim installation (default: `/opt/isaac-sim`)

## Testing

The installation is automatically tested during the container build process. You can verify the installation by running:

```bash
python.sh -c "import omni; print('Isaac Sim is working!')"
``` 
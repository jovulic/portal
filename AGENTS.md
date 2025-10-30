# Project: Portal

## Project Overview

This project, "Portal," is a containerized, remotely accessible Google Chrome browser. It is built using Nix, which ensures a reproducible and declarative environment. The container image includes:

- **Google Chrome:** The web browser.
- **Weston:** A Wayland compositor configured for headless RDP access.
- **s6-overlay:** A process supervisor for managing services within the container.
- **RDP:** For remote graphical access to the Chrome session.
- **Chrome DevTools:** Exposed for debugging and automation.

The environment inside the container is configured to be a minimal yet functional system, with modules for D-Bus, fonts, time zone, and user accounts.

## Building and Running

The project uses `nix` and `just` for building and running the container.

### Development Environment

To enter a development shell with all the necessary dependencies, run:

```bash
nix develop
```

### Building the Container

To build the container image, run:

```bash
just build
```

This will build the container image and tag it as `localhost/portal:<version>-<commit>`.

### Running the Container

To run the container locally, use:

```bash
just run
```

This will start the container and expose the following ports:

- `3389`: RDP access (user: `nomad`)
- `9222`: Chrome DevTools

### Pushing the Container

To push the container to a remote registry, use:

```bash
just push
```

## Development Conventions

- **Nix Flakes:** The project is structured as a Nix Flake, with the main entry point being `flake.nix`.
- **Modular Configuration:** The container's configuration is broken down into modules located in the `src/modules` directory. Each module is responsible for a specific part of the system (e.g., `user.nix`, `fonts.nix`).
- **`justfile`:** A `justfile` is used to provide simple commands for common development tasks.
- **s6-overlay:** Services within the container are managed by s6-overlay. Service definitions are located in the `src/modules/s6` directory and used by other modules.

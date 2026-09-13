# fishOS

This workspace provides a minimal Ubuntu latest base Linux operating system image with fishOS branding, a default Xfce desktop profile, a Calamares installer experience, a GRUB boot configuration, and an ISO build workflow.

## Contents

- `Dockerfile` builds the Ubuntu base container and installs common system packages, including Xfce, Calamares, GRUB support files, and a light desktop stack.
- `scripts/bootstrap.sh` configures a default non-root user and base directories.
- `scripts/install-branding.sh` applies fishOS branding files and default wallpaper configuration.
- `scripts/build-iso.sh` creates a `fishOS-live.iso` file in `dist/`.
- `scripts/run-xfce.sh` launches the default Xfce session.
- `scripts/fishOS-shell-wrapper.ps1` is a Windows PowerShell fallback that looks for Git Bash or Linux Bash when normal shell resolution fails.
- `scripts/bash-env-check.sh` checks for Bash, Xorriso, and Calamares availability.
- `branding/fishOS/` contains the fishOS release, issue, message-of-the-day, SVG logo, and wallpaper assets.
- `calamares/` contains Calamares branding metadata and the installer desktop shortcut.
- `grub/` contains a sample GRUB configuration for the fishOS live/install menu.
- `docker-compose.yml` provides a simple development workflow using the default Xfce desktop command.

## Build

```sh
docker build -t fishOS:latest .
```

## Run

```sh
docker run --rm -it fishOS:latest /bin/bash
```

Or with Docker Compose:

```sh
docker compose up --build
```

The default container command is set to `/usr/local/bin/run-xfce.sh`, which launches the branded Xfce desktop inside the container session.

## Bash compatibility

If Bash is missing on the host, use:

```powershell
pwsh -File scripts/fishOS-shell-wrapper.ps1
```

Or run the check script directly:

```sh
bash scripts/bash-env-check.sh
```

## Create an ISO

```sh
bash scripts/build-iso.sh
```

The resulting ISO is written to `dist/fishOS-live.iso`.

## Installer and GRUB shortcuts

- A Calamares desktop shortcut lives in `calamares/fishOS.desktop` and is copied into the default user desktop profile during branding.
- A GRUB boot menu template is provided in `grub/fishOS-grub.cfg`.


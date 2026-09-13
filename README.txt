fishOS Ubuntu Xfce Project

This folder contains a starter fishOS Ubuntu latest base OS project with Xfce desktop defaults,
Calamares installer metadata, and a GRUB live/install menu configuration.

Files:
- Dockerfile
- docker-compose.yml
- Makefile
- scripts/bootstrap.sh
- scripts/build-iso.sh
- scripts/install-branding.sh
- scripts/run-xfce.sh
- scripts/fishOS-shell-wrapper.ps1
- scripts/bash-env-check.sh
- branding/fishOS/
- calamares/
- grub/

Build:
  docker build -t fishOS:latest .

Run:
  docker run --rm -it fishOS:latest /bin/bash

Or launch the default desktop:
  docker compose up --build

ISO:
  bash scripts/build-iso.sh

Fallback Bash on Windows:
  pwsh -File scripts/fishOS-shell-wrapper.ps1

Notes:
- This is a scaffold for a fishOS branded Ubuntu Xfce live ISO workflow.
- A full Calamares and GRUB ISO build needs a real Linux/Bash-capable environment.

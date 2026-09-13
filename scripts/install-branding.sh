#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${ROOT_DIR:-/opt/fishos}"
BRAND_DIR="${ROOT_DIR}/branding/fishOS"

if [ ! -d "${BRAND_DIR}" ]; then
    echo "fishOS branding directory not found at ${BRAND_DIR}"
    exit 1
fi

echo "Installing fishOS branding"
mkdir -p /etc /usr/share/fishOS /usr/share/backgrounds/fishOS /etc/skel/Desktop /etc/skel/.config/xfce4/panel /etc/calamares /boot/grub

cp "${BRAND_DIR}/os-release" /etc/os-release
cp "${BRAND_DIR}/issue.net" /etc/issue.net
cp "${BRAND_DIR}/motd" /etc/motd
cp "${BRAND_DIR}/fishOS.svg" /usr/share/fishOS/fishOS.svg
cp "${BRAND_DIR}/fishOS-wallpaper.svg" /usr/share/backgrounds/fishOS/fishOS-wallpaper.svg
cp "${BRAND_DIR}/fishOS-wallpaper.png" /usr/share/backgrounds/fishOS/fishOS-wallpaper.png

# Calamares installer desktop shortcut / installer metadata
cp "${ROOT_DIR}/calamares/fishOS.desktop" /etc/skel/Desktop/fishOS-Install.desktop
cp "${ROOT_DIR}/calamares/branding/fishOS/branding.desc" /etc/calamares/branding/fishOS/branding.desc

# backstop default GRUB config with fishOS live config
cp "${ROOT_DIR}/grub/fishOS-grub.cfg" /boot/grub/fishOS-grub.cfg

# add a simple branding banner
printf "\n\n Welcome to fishOS \n\n" >/etc/issue
printf "\nWelcome to fishOS. Ubuntu base operating system.\n\n" >/etc/issue.net

cat >/etc/hostname <<'EOF'
fishOS
EOF

cat >/etc/skel/.config/xfce4/desktop.xml <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-desktop" version="1.0">
  <property name="backdrop" type="string" value="/usr/share/backgrounds/fishOS/fishOS-wallpaper.svg"/>
</channel>
EOF

echo "fishOS branding installed"

#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="${ROOT_DIR}/dist"
LIVE_DIR="${DIST_DIR}/live-build"
ISO_NAME="fishOS-live.iso"
ISO_PATH="${DIST_DIR}/${ISO_NAME}"
BRAND_DIR="${ROOT_DIR}/branding/fishOS"

mkdir -p "${DIST_DIR}"

# Prefer a real Ubuntu live-build artifact when `lb` is available on the runner.
if command -v lb >/dev/null 2>&1; then
    echo "live-build found; creating a real Ubuntu live image layout"
    rm -rf "${LIVE_DIR}"
    mkdir -p "${LIVE_DIR}/config/includes.chroot/etc" "${LIVE_DIR}/config/includes.chroot/usr/share/fishOS" "${LIVE_DIR}/config/package-lists"

    cp "${BRAND_DIR}/os-release" "${LIVE_DIR}/config/includes.chroot/etc/os-release"
    cp "${BRAND_DIR}/issue.net" "${LIVE_DIR}/config/includes.chroot/etc/issue.net"
    cp "${BRAND_DIR}/motd" "${LIVE_DIR}/config/includes.chroot/etc/motd"
    cp "${BRAND_DIR}/fishOS.svg" "${LIVE_DIR}/config/includes.chroot/usr/share/fishOS/fishOS.svg"

    cat > "${LIVE_DIR}/config/package-lists/fishos.list.chroot" <<'EOF'
xfce4
xfce4-goodies
xorg
xterm
lightdm
dbus-x11
fish
sudo
opendoas
calamares
xorriso
bash
ca-certificates
curl
git
jq
less
wget
squashfs-tools
live-build
EOF

    cat > "${LIVE_DIR}/config/bootloaders/grub-pc.cfg" <<'EOF'
set default=0
set timeout=5

menuentry "fishOS Live (GRUB)" {
    linux /casper/vmlinuz boot=casper quiet splash
    initrd /casper/initrd
}
EOF

    cd "${LIVE_DIR}"
    lb config noauto \
        --architecture amd64 \
        --binary-images iso-hybrid \
        --distribution focal \
        --debian-installer false \
        --bootappend-live "boot=casper quiet splash" \
        --apt-recommends false

    lb build

    rm -f "${ISO_PATH}"
    first_iso="$(find "${LIVE_DIR}/images" -type f -name '*.iso' -print -quit)"
    if [[ -n "${first_iso}" ]]; then
        cp "${first_iso}" "${ISO_PATH}"
    else
        echo "live-build created no ISO artifact"
        exit 1
    fi

    echo "Created ${ISO_PATH}"
    exit 0
fi

# Fallback for builders without `lb`: emit an xorriso ISO image from a synthetic root.
# This is accepted only as a compatibility release artifact; the platform still needs
# a real kernel/initrd and filesystem.squashfs from live-build for a genuine bootable image.
ISO_ROOT="${DIST_DIR}/fishOS-live-root"
mkdir -p "${ISO_ROOT}/boot/grub" "${ISO_ROOT}/casper" "${ISO_ROOT}/etc" "${ISO_ROOT}/usr/share/fishOS"

cp "${BRAND_DIR}/os-release" "${ISO_ROOT}/etc/os-release"
cp "${BRAND_DIR}/issue.net" "${ISO_ROOT}/etc/issue.net"
cp "${BRAND_DIR}/motd" "${ISO_ROOT}/etc/motd"
cp "${BRAND_DIR}/fishOS.svg" "${ISO_ROOT}/usr/share/fishOS/fishOS.svg"

cat > "${ISO_ROOT}/boot/grub/grub.cfg" <<EOF
set default=0
set timeout=5

menuentry "fishOS Live (GRUB)" {
    linux /casper/vmlinuz boot=casper quiet splash
    initrd /casper/initrd
}
EOF

if command -v xorriso >/dev/null 2>&1; then
    echo "xorriso found; building compatibility ISO"
    rm -f "${ISO_PATH}"
    xorriso -as mkisofs \
        -iso-level 3 \
        -full-iso9660-filenames \
        -volid "fishOS" \
        -output "${ISO_PATH}" \
        "${ISO_ROOT}"
else
    echo "No supported ISO builder found. Install live-build or xorriso."
    exit 1
fi

echo "Created ${ISO_PATH}"

#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="${ROOT_DIR}/dist"
ISO_ROOT="${DIST_DIR}/fishOS-live-root"
ISO_NAME="fishOS-live.iso"
ISO_PATH="${DIST_DIR}/${ISO_NAME}"
BRAND_DIR="${ROOT_DIR}/branding/fishOS"

mkdir -p "${DIST_DIR}" "${ISO_ROOT}/boot/grub" "${ISO_ROOT}/etc" "${ISO_ROOT}/usr/share/fishOS"

cp "${BRAND_DIR}/os-release" "${ISO_ROOT}/etc/os-release"
cp "${BRAND_DIR}/issue.net" "${ISO_ROOT}/etc/issue.net"
cp "${BRAND_DIR}/motd" "${ISO_ROOT}/etc/motd"
cp "${BRAND_DIR}/fishOS.svg" "${ISO_ROOT}/usr/share/fishOS/fishOS.svg"

cat > "${ISO_ROOT}/boot/grub/grub.cfg" <<EOF
set default=0
set timeout=5

menuentry "fishOS Live" {
    linux /casper/vmlinuz boot=casper quiet splash
    initrd /casper/initrd
}
EOF

if ! command -v xorriso >/dev/null 2>&1; then
    echo "xorriso is required to build an ISO image. Install it with:"
    echo "sudo apt-get update && sudo apt-get install -y xorriso"
    exit 1
fi

rm -f "${ISO_PATH}"
xorriso -as mkisofs \
    -iso-level 3 \
    -full-iso9660-filenames \
    -volid "fishOS" \
    -output "${ISO_PATH}" \
    "${ISO_ROOT}"

echo "Created ${ISO_PATH}"

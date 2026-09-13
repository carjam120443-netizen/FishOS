#!/usr/bin/env bash
set -euo pipefail

FISHOS_HOME="${FISHOS_HOME:-/opt/fishos}"
BRAND_DIR="${FISHOS_HOME}/branding/fishOS"
TARGET_DIR="${TARGET_DIR:-/usr/share/fishOS}"

mkdir -p "${TARGET_DIR}" /etc/skel/.config /usr/share/fishOS
cp "${BRAND_DIR}/fishOS.svg" "${TARGET_DIR}/fishOS.svg"
cp "${BRAND_DIR}/fishOS.svg" "/usr/share/fishOS/fishOS.svg"

cat > /etc/skel/.config/neofetch.conf <<'EOF'
# fishOS Neofetch configuration
print_info() {
    info title
    info underline
    info "OS" distro
    info "Host" model
    info "Kernel" kernel
    info "Uptime" uptime
    info "Packages" packages
    info "Shell" shell
    info "DE" de
    info "CPU" cpu
    info "GPU" gpu
    info "Memory" memory
}

image_backend="ascii"
image_source="/usr/share/fishOS/fishOS.svg"
EOF

cat > /etc/skel/.config/fastfetch.json <<'EOF'
{
  "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
  "logo": {
    "source": "/usr/share/fishOS/fishOS.svg",
    "type": "file",
    "height": 14,
    "width": 24
  },
  "display": {
    "separator": " : "
  }
}
EOF

echo "fishOS fetch branding installed"

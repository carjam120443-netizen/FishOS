#!/usr/bin/env bash
set -euo pipefail

echo "[fishOS] Configuring Ubuntu latest base environment with Xfce desktop"

# Ensure the default app directory is owned by an app user in the image
if ! id -u ubuntu >/dev/null 2>&1; then
    useradd -m -s /bin/bash ubuntu
fi

if ! getent group sudo >/dev/null 2>&1; then
    groupadd sudo
fi

usermod -aG sudo ubuntu
mkdir -p /opt/base-linux /opt/fishos /etc/skel/.config/xfce4
chown -R ubuntu:ubuntu /opt/base-linux /opt/fishos

cat >/etc/skel/.config/xfce4/helpers.rc <<'EOF'
TerminalEmulator=/usr/bin/xterm
EOF

cat >/etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-panel" version="1.0">
  <property name="panels" type="array">
    <value type="int" value="1"/>
  </property>
</channel>
EOF

mkdir -p /etc/base-linux
cat >/etc/base-linux/hostname <<'EOF'
fishOS
EOF

echo "[fishOS] Bootstrap complete"

#!/usr/bin/env bash
set -euo pipefail

export DESKTOP_SESSION=xfce
export XDG_CURRENT_DESKTOP=Xfce

if command -v /usr/bin/startxfce4 >/dev/null 2>&1; then
    exec /usr/bin/startxfce4
else
    echo "Xfce desktop command not found; install xfce4 package first."
    exec /bin/bash
fi

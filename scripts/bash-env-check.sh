#!/usr/bin/env bash
set -euo pipefail

echo "fishOS Bash environment compatibility check"
echo "Shell: ${SHELL:-/bin/bash}"

if command -v bash >/dev/null 2>&1; then
    echo "bash found at $(command -v bash)"
else
    echo "bash not found in PATH; install bash or use a Linux environment"
fi

if command -v xorriso >/dev/null 2>&1; then
    echo "xorriso found at $(command -v xorriso)"
else
    echo "xorriso not found in PATH; ISO generation requires xorriso"
fi

if command -v calamares >/dev/null 2>&1; then
    echo "calamares found at $(command -v calamares)"
else
    echo "calamares not found in PATH; install calamares package"
fi

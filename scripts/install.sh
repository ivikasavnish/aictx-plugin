#!/usr/bin/env bash
# Install aictx CLI binary
set -e

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case "$ARCH" in
  x86_64) ARCH="amd64" ;;
  aarch64|arm64) ARCH="arm64" ;;
  *) echo "unsupported arch: $ARCH"; exit 1 ;;
esac

RELEASE="https://github.com/ivikasavnish/aictx/releases/latest/download/aictx-${OS}-${ARCH}"
DEST="${HOME}/.local/bin/aictx"

mkdir -p "$(dirname "$DEST")"
echo "downloading aictx → $DEST"
curl -fsSL "$RELEASE" -o "$DEST"
chmod +x "$DEST"
echo "aictx installed. run: aictx --help"

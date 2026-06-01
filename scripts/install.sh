#!/usr/bin/env bash
# Install aictx CLI binary
# Verifies sha256 checksum before installing.
set -euo pipefail

VERSION="${AICTX_VERSION:-v0.1.0}"

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case "$OS" in
  linux|darwin) ;;
  msys*|mingw*|cygwin*) OS="windows" ;;
  *) echo "unsupported OS: $OS"; exit 1 ;;
esac

case "$ARCH" in
  x86_64)       ARCH="amd64" ;;
  aarch64|arm64) ARCH="arm64" ;;
  *) echo "unsupported arch: $ARCH"; exit 1 ;;
esac

BASE="https://github.com/ivikasavnish/aictx/releases/download/${VERSION}"

if [ "$OS" = "windows" ]; then
  BINARY="aictx-${OS}-${ARCH}.exe"
  DEST="${HOME}/.local/bin/aictx.exe"
else
  BINARY="aictx-${OS}-${ARCH}"
  DEST="${HOME}/.local/bin/aictx"
fi

TMP=$(mktemp)
SUM=$(mktemp)

cleanup() { rm -f "$TMP" "$SUM"; }
trap cleanup EXIT

mkdir -p "$(dirname "$DEST")"

echo "downloading aictx ${VERSION} (${OS}/${ARCH})..."
curl -fsSL "${BASE}/${BINARY}"        -o "$TMP"
curl -fsSL "${BASE}/${BINARY}.sha256" -o "$SUM"

echo "verifying checksum..."
EXPECTED=$(cat "$SUM")

# macOS ships shasum not sha256sum
if command -v sha256sum >/dev/null 2>&1; then
  ACTUAL=$(sha256sum "$TMP" | awk '{print $1}')
elif command -v shasum >/dev/null 2>&1; then
  ACTUAL=$(shasum -a 256 "$TMP" | awk '{print $1}')
else
  echo "no sha256 tool found — skipping checksum (install coreutils or shasum)"
  ACTUAL="$EXPECTED"
fi

if [ "$EXPECTED" != "$ACTUAL" ]; then
  echo "checksum mismatch — aborting"
  echo "  expected: $EXPECTED"
  echo "  got:      $ACTUAL"
  exit 1
fi

mv "$TMP" "$DEST"
chmod +x "$DEST"
echo "aictx ${VERSION} installed → $DEST"
echo "run: aictx --help"

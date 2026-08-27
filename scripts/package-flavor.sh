#!/usr/bin/env bash
# package-flavor.sh — create a reviewable .tar.zst (or .tar.gz) Harbor Flavor.
set -euo pipefail
if [[ $# -ne 1 ]]; then
  echo "Usage: package-flavor.sh <flavor-dir>" >&2
  exit 2
fi
SRC=$(cd "$1" && pwd)
NAME=$(basename "$SRC")
OUT_DIR="$(cd "$(dirname "$0")/.." && pwd)/dist"
mkdir -p "$OUT_DIR"
STAGE=$(mktemp -d)
trap 'rm -rf "$STAGE"' EXIT
cp -a "$SRC" "$STAGE/$NAME"
(
  cd "$STAGE/$NAME"
  find . -type f ! -name checksums.sha256 -print0 | sort -z | xargs -0 sha256sum > checksums.sha256
)
TAR="$OUT_DIR/${NAME}.tar"
tar -C "$STAGE" -cf "$TAR" "$NAME"
if command -v zstd >/dev/null 2>&1; then
  zstd -f -q "$TAR"
  ARTIFACT="${TAR}.zst"
  rm -f "$TAR"
else
  gzip -f "$TAR"
  ARTIFACT="${TAR}.gz"
fi
sha256sum "$ARTIFACT" | tee "$OUT_DIR/${NAME}.sha256"
echo "wrote $ARTIFACT"

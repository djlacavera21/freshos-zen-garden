#!/usr/bin/env bash
# apply-flavor.sh — install a Harbor Flavor onto a FreshOS/Mint host.
set -euo pipefail
DRY=0
INSTALL_PKGS=0
FLAVOR=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY=1; shift ;;
    --install-packages) INSTALL_PKGS=1; shift ;;
    -h|--help)
      echo "Usage: apply-flavor.sh [--dry-run] [--install-packages] <flavor-dir>"
      exit 0
      ;;
    *) FLAVOR="$1"; shift ;;
  esac
done
[[ -n "$FLAVOR" ]] || { echo "Usage: apply-flavor.sh [--dry-run] [--install-packages] <flavor-dir>" >&2; exit 2; }

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
"$ROOT/scripts/validate-flavor.sh" "$FLAVOR"

DIR=$(cd "$FLAVOR" && pwd)
YAML="$DIR/harbor-flavor.yaml"
ID=$(awk '/^  id:/{print $2; exit}' "$YAML")
VER=$(awk '/^  version:/{print $2; exit}' "$YAML")
SHARE="${FRESHOS_SHARE:-/usr/local/share/freshos}"
DEST="$SHARE/flavors/$ID"

echo "flavor  $ID@$VER"
echo "source  $DIR"
echo "dest    $DEST"

if [[ $DRY -eq 1 ]]; then
  echo "dry-run: would copy YAML/theme/prompts into $DEST"
  echo "dry-run: would write $SHARE/current-flavor"
  echo "dry-run: would restart freshos-visualizer.service if installed"
  if [[ $INSTALL_PKGS -eq 1 ]]; then
    echo "dry-run: would apt-get install packages.extra (not executed)"
  fi
  exit 0
fi

if [[ $(id -u) -ne 0 ]]; then
  echo "apply (non-dry-run) needs root so files land in $SHARE" >&2
  echo "re-run with: sudo $0 $DIR" >&2
  exit 1
fi

mkdir -p "$DEST" "$SHARE/prompts"
install -m 0644 "$YAML" "$DEST/harbor-flavor.yaml"
[[ -f "$DIR/README.md" ]] && install -m 0644 "$DIR/README.md" "$DEST/README.md"
[[ -f "$DIR/theme.json" ]] && install -m 0644 "$DIR/theme.json" "$DEST/theme.json"
if [[ -d "$DIR/prompts" ]]; then
  mkdir -p "$DEST/prompts"
  find "$DIR/prompts" -maxdepth 1 -type f -name '*.md' -exec install -m 0644 {} "$DEST/prompts/" \;
  find "$DIR/prompts" -maxdepth 1 -type f -name '*.md' -exec install -m 0644 {} "$SHARE/prompts/" \;
fi

{
  echo "$ID"
  echo "$VER"
  date -u +%Y-%m-%dT%H:%M:%SZ
} > "$SHARE/current-flavor"

if systemctl list-unit-files | grep -q '^freshos-visualizer.service'; then
  systemctl restart freshos-visualizer.service || true
fi

echo "applied $ID@$VER"

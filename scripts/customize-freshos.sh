#!/usr/bin/env bash
# customize-freshos.sh — transform a Mint 22.x (or Cubic chroot) into FreshOS Harbor base.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SHARE="${FRESHOS_SHARE:-/usr/local/share/freshos}"
PREFIX="${FRESHOS_PREFIX:-/usr/local}"

if [[ $(id -u) -ne 0 ]]; then
  echo "Run as root (live system or Cubic chroot)." >&2
  exit 1
fi

echo "== FreshOS Harbor base =="
echo "source $ROOT"

mkdir -p "$SHARE" "$PREFIX/bin" /etc/systemd/system
cp -a "$ROOT/visualizer" "$SHARE/visualizer"
cp -a "$ROOT/grok-zen-master" "$SHARE/grok-zen-master"
cp -a "$ROOT/flavors" "$SHARE/flavors"
cp -a "$ROOT/catalog" "$SHARE/catalog"
mkdir -p "$SHARE/prompts"
[[ -d "$ROOT/prompts" ]] && cp -a "$ROOT/prompts/." "$SHARE/prompts/" || true

install -m 0755 "$ROOT/scripts/serve-visualizer.sh" "$PREFIX/bin/freshos-visualizer"
install -m 0755 "$ROOT/scripts/serve-zen-master.sh" "$PREFIX/bin/freshos-zen-master"
install -m 0755 "$ROOT/scripts/apply-flavor.sh" "$PREFIX/bin/freshos-apply-flavor"
install -m 0755 "$ROOT/scripts/validate-flavor.sh" "$PREFIX/bin/freshos-validate-flavor"
install -m 0755 "$ROOT/scripts/package-flavor.sh" "$PREFIX/bin/freshos-package-flavor"

if [[ -d "$ROOT/systemd" ]]; then
  install -m 0644 "$ROOT/systemd/"*.service /etc/systemd/system/ || true
  systemctl daemon-reload || true
  systemctl enable --now freshos-visualizer.service 2>/dev/null || true
fi

# Branding — safe even if /etc/os-release is immutable in some chroots
if [[ -w /etc/os-release ]]; then
  if ! grep -q FreshOS /etc/os-release; then
    echo "PRETTY_NAME=\"FreshOS 1.0 Zen Garden (Harbor)\"" >> /etc/os-release || true
  fi
fi

"$ROOT/scripts/apply-flavor.sh" "$ROOT/flavors/official/zen-garden" || true

cat > /usr/local/share/freshos/FIRST-BOOT.txt << 'BOOT'
FreshOS Zen Garden — Harbor base is installed.

  Visualizer:  http://127.0.0.1:8080
  Zen Master:  http://127.0.0.1:4200/docs   (optional, needs XAI_API_KEY)
  Experimentals catalog (offline):
      python3 -m http.server 8787 --directory /usr/local/share/freshos
      then browse experimentals/ if you copied that tree, or open the GitHub portal.

The operator remains Emperor. Grok is Vizier.
BOOT

echo "done. open http://127.0.0.1:8080 after starting freshos-visualizer"

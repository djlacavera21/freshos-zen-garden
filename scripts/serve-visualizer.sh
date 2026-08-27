#!/usr/bin/env bash
# Serve the Zen Garden visualizer on localhost:8080 without extra deps.
set -euo pipefail
DIR="${FRESHOS_VISUALIZER_DIR:-$(cd "$(dirname "$0")/../visualizer" && pwd)}"
PORT="${FRESHOS_VISUALIZER_PORT:-8080}"
cd "$DIR"
if command -v python3 >/dev/null 2>&1; then
  exec python3 -m http.server "$PORT" --bind 127.0.0.1
fi
echo "python3 required to serve $DIR" >&2
exit 1

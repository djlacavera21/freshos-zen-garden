#!/usr/bin/env bash
set -euo pipefail
DIR="${FRESHOS_ZEN_DIR:-$(cd "$(dirname "$0")/../grok-zen-master" && pwd)}"
cd "$DIR"
if [[ -f .venv/bin/uvicorn ]]; then
  exec .venv/bin/uvicorn app:app --host 127.0.0.1 --port 4200
fi
if command -v uvicorn >/dev/null 2>&1; then
  exec uvicorn app:app --host 127.0.0.1 --port 4200
fi
echo "Install FastAPI + uvicorn to run the optional Zen Master (see grok-zen-master/README.md)." >&2
exit 1

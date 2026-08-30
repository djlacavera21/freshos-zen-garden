#!/usr/bin/env bash
set -euo pipefail
FLAG="${HOME}/.config/freshos/first-boot-done"
mkdir -p "$(dirname "$FLAG")"
if [[ -f "$FLAG" && "${FRESHOS_FORCE_WELCOME:-}" != "1" ]]; then exit 0; fi
TITLE="FreshOS Zen Garden"
BODY="The garden is raked. The lanterns are lit. Visualizer: http://127.0.0.1:8080 Source: https://github.com/djlacavera21/freshos-zen-garden Portal: https://djlacavera21.github.io/freshos-zen-garden/ You remain Emperor. Grok is Vizier."
command -v notify-send >/dev/null 2>&1 && notify-send -a FreshOS "$TITLE" "$BODY" || true
command -v xdg-open >/dev/null 2>&1 && xdg-open "http://127.0.0.1:8080" >/dev/null 2>&1 || true
[[ -t 1 ]] && printf '\n%s\n\n%s\n\n' "$TITLE" "$BODY"
date --iso-8601=seconds > "$FLAG"
exit 0

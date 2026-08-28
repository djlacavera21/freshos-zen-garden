#!/usr/bin/env bash
# validate-flavor.sh — static checks for harbor-flavor/1.0
set -euo pipefail
if [[ $# -lt 1 ]]; then
  echo "Usage: validate-flavor.sh <flavor-dir>" >&2
  exit 2
fi
DIR=$(cd "$1" && pwd)
YAML="$DIR/harbor-flavor.yaml"
fail() { echo "FAIL: $*" >&2; exit 1; }
warn() { echo "WARN: $*" >&2; }

[[ -f "$YAML" ]] || fail "missing harbor-flavor.yaml"

grep -q '^apiVersion: harbor-flavor/1.0' "$YAML" || fail "apiVersion must be harbor-flavor/1.0"
grep -q '^kind: Flavor' "$YAML" || fail "kind must be Flavor"

id=$(awk '/^  id:/{print $2; exit}' "$YAML")
[[ "$id" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || fail "metadata.id must be kebab-case (got '$id')"

grep -qE '^[[:space:]]+telemetry:[[:space:]]*false' "$YAML" || fail "network.telemetry must be false"
grep -qE '^[[:space:]]+noKernelModules:[[:space:]]*true' "$YAML" || fail "safety.noKernelModules must be true"
grep -qE '^[[:space:]]+noSetuid:[[:space:]]*true' "$YAML" || fail "safety.noSetuid must be true"
grep -qE '^[[:space:]]+noHiddenCron:[[:space:]]*true' "$YAML" || fail "safety.noHiddenCron must be true"
grep -qE '^[[:space:]]+project:[[:space:]]*freshos-zen-garden' "$YAML" || fail "base.project must be freshos-zen-garden"

found=$(find "$DIR" -type f \( -name '*.iso' -o -name '*.img' -o -name '*.bin' -o -name '*.ko' -o -name '*.deb' -o -name '*.rpm' \) | head)
[[ -z "$found" ]] || fail "forbidden artifact: $found"

# setuid/setgid — portable, no process substitution
stat_out=$(find "$DIR" -type f -exec stat -c '%a %n' {} +)
while read -r mode path; do
  [[ -z "${mode:-}" ]] && continue
  # setuid/setgid appear as 4-digit modes (e.g. 4755). 644 is fine.
  if [[ ${#mode} -ge 4 ]]; then
    fail "setuid/setgid-ish mode $mode on $path"
  fi
done <<ST
$stat_out
ST

if grep -qE '^[[:space:]]+hooksAllowed:[[:space:]]*true' "$YAML"; then
  warn "hooksAllowed: true — every hook must be reviewed line by line"
else
  if [[ -d "$DIR/hooks" ]] && find "$DIR/hooks" -type f | grep -q .; then
    fail "hooks/ present but safety.hooksAllowed is not true"
  fi
fi

if awk '/^packages:/{p=1} p && /^[^[:space:]]/{if(!/^packages:/) p=0} p' "$YAML" | grep -Eq 'https?://|`|\$\('; then
  fail "packages block must not contain URLs or command substitutions"
fi

echo "OK  $id  ($DIR)"

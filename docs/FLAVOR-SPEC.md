# Harbor Flavor Specification 1.0

A Harbor Flavor is a directory (or `.tar.zst` of that directory) that customizes FreshOS without replacing the operating system.

## Layout

```
my-flavor/
  harbor-flavor.yaml     # required
  README.md              # required for catalog listing
  theme.json             # optional visualizer theme
  prompts/               # optional Vizier prompts
  overlay/               # optional files copied under /usr/local/share/freshos/overlay
  hooks/                 # optional, review-gated shell snippets
```

Packaged as `dist/my-flavor.tar.zst` plus `dist/my-flavor.sha256` by `scripts/package-flavor.sh`.

## `harbor-flavor.yaml`

```yaml
apiVersion: harbor-flavor/1.0
kind: Flavor
metadata:
  id: kebab-case-id
  name: Human title
  version: 1.0.0
  authors: [{name: ..., github: ...}]
  license: MIT
  tags: [research]
  visibility: public
base:
  project: freshos-zen-garden
  version: "1.0"
  minCompatible: "1.0"
intent:
  summary: one short paragraph
  emperorGoals: [sovereignty first]
  agency: graduated          # observe | graduated | autonomous-with-override
modules:
  enable: [research, archives]
  disable: [publishing]
  optional: [war-room]
packages:
  extra: []                  # apt names only, no URLs
  remove: []
theme:
  visualizer: theme.json
  plymouth: zen-garden
  cinnamonPreset: zen-garden
  accent: "#c4a35a"
grok:
  enabled: optional
  personality: prompts/zen-master.md
  defaultModelHint: grok-4
  requireApiKey: false
services:
  visualizer: true
  zenMaster: optional
  extraSystemd: []
network:
  telemetry: false           # MUST be false
  outboundDefault: operator  # deny | operator | allow-listed
  allowedLocalPorts: [8080, 4200]
safety:
  hooksAllowed: false
  hooksMustBeReviewed: true
  noKernelModules: true
  noSetuid: true
  noHiddenCron: true
```

## Hard rejects

`scripts/validate-flavor.sh` fails the flavor if any of these are true:

- Missing `harbor-flavor.yaml` or `apiVersion` ≠ `harbor-flavor/1.0`
- `metadata.id` not kebab-case
- `network.telemetry` is not `false`
- `safety.noKernelModules` / `noSetuid` / `noHiddenCron` not `true`
- Files with extensions `.iso` `.img` `.bin` `.ko` `.deb` `.rpm`
- Mode `4000`/`2000` (setuid/setgid) anywhere in the tree
- Hook scripts present while `safety.hooksAllowed` is `false`
- `packages.extra` contains a URL or `$(` / backtick

## Apply model

`apply-flavor.sh` is intentionally conservative:

1. Validate.
2. Copy YAML + theme + prompts into `/usr/local/share/freshos/flavors/<id>/`.
3. Write `/usr/local/share/freshos/current-flavor`.
4. Restart `freshos-visualizer.service` if present.
5. Never run `apt` unless `--install-packages` is passed *and* the operator is root.
6. Never enable extra systemd units from the flavor in Phase 1.

Dry-run is the default posture for review (`--dry-run`).

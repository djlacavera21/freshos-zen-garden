# Contributing a Harbor Flavor

Today the catalog is this Git repository. Tomorrow a Grok App Experimentals submenu *might* accept Premium+ uploads of the same package. Author once; both paths can consume it.

## Steps

1. Copy `flavors/official/zen-garden` to `flavors/examples/your-id`.
2. Edit `harbor-flavor.yaml`. Change `metadata.id` (kebab-case) and intent.
3. Keep the overlay small. No ISOs, no kernel modules, no setuid.
4. Write a short `README.md`.
5. Run `./scripts/apply-flavor.sh --dry-run flavors/examples/your-id`.
6. Run `./scripts/package-flavor.sh flavors/examples/your-id`.
7. Open a pull request. Maintainers review YAML and hooks in the open.

## Review bar

- Schema `harbor-flavor/1.0`
- Base pin `freshos-zen-garden`
- `telemetry: false`
- Hooks reviewed line by line if present
- License present
- No attempt to impersonate an official xAI image

Premium+ status is irrelevant on GitHub. It would only gate an official App upload UI.

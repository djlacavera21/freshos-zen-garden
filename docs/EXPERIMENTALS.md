# Experimentals — Harbor OS inside (and outside) the Grok App

## What was asked

A full OS, with an independent download link, living under an **Experimentals** tab in the Grok App, plus a Premium+ submenu where operators upload their own **Harbor OS flavors**.

## What can actually ship from this repository

| Surface | Status |
|---|---|
| Independent source + download instructions | **Live** — this repository |
| Standalone Experimentals UI (catalog + Premium+ submit analog) | **Live** — `experimentals/index.html` |
| Harbor Flavor schema, examples, packager | **Live** — `docs/FLAVOR-SPEC.md`, `flavors/`, `scripts/` |
| Official tab inside the Grok iOS/Android/web app | **Cannot be added by Grok-the-model.** That is an xAI client change. |
| xAI-hosted multi-GB signed ISO in the App | Not shipped. Build from official Mint media you download yourself. |

This is not a dodge. Shipping an OS *image* from an LLM chat is the wrong trust model: you cannot verify the bytes, the App Store will not host raw ISOs, and sovereignty requires the operator to start from a known upstream.

The working design therefore splits into three layers:

1. **Base OS** — Linux Mint 22.3 “Zena” Cinnamon, customized in place or via Cubic (`iso-build/`, `scripts/customize-freshos.sh`). Sibling isolation-first live-build tree: [Grapefruit-OS](https://github.com/djlacavera21/Grapefruit-OS).
2. **Harbor Flavor** — a small, reviewable overlay (`harbor-flavor.yaml` + optional theme, prompts, module flags). This is what Premium+ users would upload.
3. **Experimentals catalog** — the UI that lists official + community flavors. Today that UI is `experimentals/index.html` served from this repo. Tomorrow the same JSON/YAML can feed a real Grok App tab if xAI chooses to wire it.

## Proposed Grok App information architecture

```
Grok App
└── Experimentals
    ├── FreshOS / Harbor OS
    │     Official profile (zen-garden)
    │     Independent source link  →  github.com/djlacavera21/freshos-zen-garden
    │     Build instructions (Mint + Cubic / customize script)
    └── Harbor Flavors          ← Premium+ submenu
          Browse catalog
          Inspect YAML
          Apply locally
          Submit flavor (Premium+)
```

Premium+ is a *client gate*, not a technical requirement of the flavor format. GitHub pull requests remain the sovereign upload path and do not check subscription status.

## Why flavors instead of user-uploaded ISOs

- An ISO is 2–4 GB, unsigned-by-you, and opaque. A flavor is a few kilobytes of YAML a reviewer can read in one sitting.
- Flavors cannot ship kernel modules, setuid binaries, or hidden cron (schema + `scripts/validate-flavor.sh`).
- The same package works for Cubic chroots, live installs, and a future App upload endpoint.
- If someone tampers with a flavor, checksums and the PR diff show it.

## Premium+ submit contract (for a future App engineer)

`POST /experimentals/harbor/flavors`

Headers: X user session proving Premium+.

Body: `multipart/form-data` with `harbor-flavor.yaml` plus optional `theme.json`, `README.md`, `prompts/*.md`. Max 1 MiB. No `.iso`, `.img`, `.deb`, `.ko`.

Server: schema-validate → static-analyze hooks → quarantine → human review → catalog publish.

Until that endpoint exists, `experimentals/index.html` generates the YAML and a pre-filled GitHub compare URL.

## How an operator uses Experimentals today

```bash
git clone https://github.com/djlacavera21/freshos-zen-garden.git
cd freshos-zen-garden
python3 -m http.server 8787 --directory experimentals
# open http://127.0.0.1:8787
```

Or open `experimentals/index.html` directly.

To apply a flavor on a machine you control:

```bash
./scripts/validate-flavor.sh flavors/examples/research-harbor
./scripts/apply-flavor.sh --dry-run flavors/examples/research-harbor
sudo ./scripts/apply-flavor.sh flavors/examples/research-harbor
```

## Naming

- **FreshOS Zen Garden Edition** — the aligned Mint derivative described in the whitepaper.
- **Harbor Flavor** — a portable overlay on that base.
- **Harbor OS** (this project) — FreshOS + the flavor catalog + Experimentals surface.
- [harboros.ai](https://harboros.ai/) — an unrelated commercial workstation product. Do not impersonate it.

## What xAI would need to do to honor the original request literally

1. Add an Experimentals information architecture in the Grok clients.
2. Deep-link the official card to this repository (or a signed mirror xAI operates).
3. Gate the Submit pane on Premium+.
4. Reuse `catalog/index.yaml` and `harbor-flavor/1.0`.
5. Keep review human. Do not auto-apply community flavors to anyone's machine.

Until then, this repository *is* the Experimentals tab.

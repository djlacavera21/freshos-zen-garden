# FreshOS Zen Garden Edition — Harbor Flavors

**A Sovereign, Grok-Powered Multi-Agent Platform for Aligned Digital Empire Construction**

**Version 1.0 — August 2026**  
**Base**: Linux Mint 22.3 “Zena” (Cinnamon)  
**Independent source**: https://github.com/djlacavera21/freshos-zen-garden

This repository is the public source of truth for FreshOS and for **Harbor Flavors** — reviewable overlays that let operators (and, later, a Grok App Experimentals catalog) share variants without uploading raw ISOs.

---

## Honest scope

| Asked | Status |
|---|---|
| Full aligned OS architecture + whitepaper | Present (`docs/WHITEPAPER.md`) |
| Independent download / source link | This GitHub repository |
| Zen Garden visualizer | Prototype in `visualizer/` |
| Optional Grok Vizier | Stub API in `grok-zen-master/` |
| Community Harbor Flavors + schema | `docs/FLAVOR-SPEC.md`, `flavors/` |
| Premium+ upload submenu inside the official Grok App | **Not something Grok can ship.** Spec only: `docs/EXPERIMENTALS.md` |
| Official xAI-hosted multi-GB ISO in the App | Not shipped. Build from Mint + scripts. |

Grok cannot add tabs to the Grok App. The working analog of “Experimentals → Harbor Flavors → Premium+ upload” is: publish a flavor directory here via pull request.

---

## Quick start

```bash
git clone https://github.com/djlacavera21/freshos-zen-garden.git
cd freshos-zen-garden

# Visualizer (no root required)
./scripts/serve-visualizer.sh
# open http://127.0.0.1:8080

# Inspect a flavor without touching the system
./scripts/apply-flavor.sh --dry-run flavors/examples/research-harbor

# On a Mint 22.3 machine you control
sudo ./scripts/customize-freshos.sh
```

---

## Harbor Flavors included

| ID | Role |
|---|---|
| `zen-garden` | Official base profile |
| `research-harbor` | Research + archives, quieter garden |
| `war-room-harbor` | Strategy, bridges and lanterns |
| `airgap-tui` | Minimal / Phase-3 direction |

Catalog: `catalog/index.yaml`  
Submit guide: `docs/CONTRIBUTING-FLAVORS.md`

---

## Alignment

Sovereignty First · Visual Clarity · Value Coherence · Graduated Agency · Long-Term Orientation  

See `docs/ALIGNMENT.md`.

---

## Related trees

- https://github.com/djlacavera21/Grapefruit-OS — isolation-first live-build sibling
- https://harboros.ai/ — unrelated commercial workstation OS that happens to share the English word “Harbor”

---

*The garden is being raked. The lanterns are being lit. The work continues.*

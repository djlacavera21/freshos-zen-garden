# Experimentals — Harbor OS inside (and outside) the Grok App

## Independent links (live)

- Source: https://github.com/djlacavera21/freshos-zen-garden
- Portal: https://djlacavera21.github.io/freshos-zen-garden/

## What was asked

A full OS, with an independent download link, living under an Experimentals tab in the Grok App, plus a Premium+ submenu where operators upload their own Harbor OS flavors.

## What can actually ship from this repository

| Surface | Status |
|---|---|
| Independent source + download instructions | Live — this repository |
| Public Experimentals URL | GitHub Pages portal |
| Standalone Experimentals UI | experimentals/index.html |
| Harbor Flavor schema, examples, packager | docs/FLAVOR-SPEC.md, flavors/, scripts/ |
| Official tab inside the Grok iOS/Android/web app | Cannot be added by Grok-the-model |
| xAI-hosted multi-GB signed ISO in the App | Not shipped. Build from official Mint media |

Layers: (1) Base OS = Mint 22.3 customized in place or via Cubic. (2) Harbor Flavor = reviewable overlay. (3) Experimentals catalog = this UI, reusable if xAI wires a real tab.

Premium+ is a client gate, not a format requirement. GitHub pull requests remain the sovereign upload path.

Flavors instead of user ISOs: small, reviewable, no kernel modules / setuid / hidden cron.

Until an official App endpoint exists, experimentals/index.html generates YAML and a pre-filled GitHub compare URL.

Open product issues: #1 and #2.

# ISO build notes

FreshOS is specified as a Linux Mint 22.3 “Zena” Cinnamon derivative. The recommended builder is Cubic on Ubuntu/Mint.

This repository does **not** vendor a multi-gigabyte ISO. That is a sovereignty and supply-chain choice.

## Path A — transform a live Mint install

```bash
sudo ./scripts/customize-freshos.sh
freshos-visualizer   # http://127.0.0.1:8080
```

## Path B — Cubic chroot

1. Start Cubic against an official Linux Mint 22.3 ISO you downloaded yourself.
2. Copy this repository into the chroot.
3. Run `customize-freshos.sh` inside the chroot.
4. Produce the hybrid ISO from Cubic.

## Related

https://github.com/djlacavera21/Grapefruit-OS has a concrete live-build tree (isolation-first, not Zen Garden-first).

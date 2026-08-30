# Cubic recipe — FreshOS Harbor base

Do not download an ISO from this repository. Start from official Linux Mint 22.3 Cinnamon media (verify SHA256 + GPG), clone this tree, run Cubic, copy the repo into the chroot, then:

```bash
cd /opt/freshos
chmod +x scripts/*.sh first-boot/welcome.sh
sudo ./scripts/customize-freshos.sh
```

Sibling isolation-first live-build: https://github.com/djlacavera21/Grapefruit-OS

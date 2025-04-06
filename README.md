<h1 align="center">Openwrt-Wireguard</h1>
<h3 align="center">Wirguard Automation</h3>

<p align="center">
<a href="#">
<img src="https://img.shields.io/github/last-commit/homelab-toolchain/openwrt-wireguard/main?style=for-the-badge"/>
</a>
</p>

---

# How to Execute

```
opkg update && opkg install git git-http

git clone https://github.com/homelab-toolchain/openwrt-wireguard.git /openwrt-wireguard

chmod -R +x /openwrt-wireguard/*

ash /openwrt-wireguard/setup.sh
```

Optional:

```
# cronjob
...
```

---

# Connect to VPN Provider

## Mullvad

Go to provider -> mullvad

## Other

...
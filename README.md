# General

...


# Setup

```
opkg update && opkg install git git-http

git clone https://github.com/homelab-toolchain/openwrt-wireguard.git /openwrt-wireguard

chmod -R +x /openwrt-wireguard/*

ash /openwrt-wireguard/setup.sh
```

Optional:

```
# cronjob
```

# Enable VPN Provider

## Mullvad

```
ash /openwrt-wireguard/provider/mullvad/setup.sh
```
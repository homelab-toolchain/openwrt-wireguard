#!/bin/ash
# shellcheck shell=dash

# --------------------------------
# Export environment variables
# --------------------------------
. /openwrt-wireguard/provider/mullvad/init_envs.sh
# --------------------------------

# --------------------------------
# Configure DNS
# --------------------------------
uci delete dhcp.@dnsmasq[0].server > /dev/null 2>&1
uci add_list dhcp.@dnsmasq[0].server="$DNS_IP"
uci commit dhcp
/etc/init.d/odhcpd restart
# --------------------------------
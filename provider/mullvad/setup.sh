#!/bin/ash
# shellcheck shell=dash

# --------------------------------
# Export environment variables
# --------------------------------
. /openwrt-wireguard/provider/mullvad/init_envs.sh
# --------------------------------

# --------------------------------
# Configure Wireguard Interface
# --------------------------------
uci set network.wg0.private_key="$PRIVATE_KEY"
uci delete network.wg0.addresses > /dev/null 2>&1
uci add_list network.wg0.addresses='10.72.130.131/32'
uci add_list network.wg0.addresses='fc00:bbbb:bbbb:bb01::9:8282/128'
uci commit network
/etc/init.d/network restart
# --------------------------------

# --------------------------------
# Configure DNS
# --------------------------------
ash change_default_dns.sh
# --------------------------------

# --------------------------------
# Configure Wireguard Peer
# --------------------------------
ash enable_next_peer.sh
# --------------------------------
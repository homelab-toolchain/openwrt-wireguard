#!/bin/ash
# shellcheck shell=dash

# input: private-key, country_code



# --------------------------------
# Configure Wireguard Interface
# --------------------------------
uci set network.wg0.private_key="$PRIVATE_KEY"
uci add_list network.wg0.addresses='10.72.130.131/32'
uci add_list network.wg0.addresses='fc00:bbbb:bbbb:bb01::9:8282/128'
uci commit network
/etc/init.d/network restart
# --------------------------------

# --------------------------------
# Configure DHCP
# --------------------------------
uci delete dhcp.@dnsmasq[0].server;
uci add_list dhcp.@dnsmasq[0].server='10.64.0.1'
uci commit dhcp
/etc/init.d/odhcpd restart
# --------------------------------

# --------------------------------
# Configure Wireguard Peer
# --------------------------------
./set_random_peer.sh "$COUNTRY_CODE"
# --------------------------------
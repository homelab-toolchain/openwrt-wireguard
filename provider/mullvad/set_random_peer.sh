#!/bin/ash

# --------------------------------
# Configure Wireguard Peer
# --------------------------------
for i in $(uci show network | grep '=wireguard_wg0' | cut -d'[' -f2 | cut -d']' -f1 | sort -nr); do uci delete network.@wireguard_wg0[$i]; done
uci add network wireguard_wg0
uci set network.@wireguard_wg0[0].description='wg-001'
uci set network.@wireguard_wg0[0].public_key='UrQiI9ISdPPzd4ARw1NHOPKKvKvxUhjwRjaI0JpJFgM='
uci add_list network.@wireguard_wg0[0].allowed_ips='0.0.0.0/0'
uci add_list network.@wireguard_wg0[0].allowed_ips='::0/0'
uci set network.@wireguard_wg0[0].route_allowed_ips='1'
uci set network.@wireguard_wg0[0].endpoint_host='193.32.249.66'
uci set network.@wireguard_wg0[0].endpoint_port='443'
uci commit network
/etc/init.d/network reload
ifdown wg0 && ifup wg0
# --------------------------------
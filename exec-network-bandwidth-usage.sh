#!/bin/sh

INTERVAL="${COLLECTD_INTERVAL:-60}"
if [ -f "/etc/openwrt_release" ] || [ -f "/etc/openwrt_version" ]; then
    # no hostname command on OpenWRT
    HOSTNAME="${COLLECTD_HOSTNAME:-$(uci get system.@system[0].hostname)}"
    # BusyBox' sleep doesn't support floating point parameters
    INTERVAL=${INTERVAL%%.*}
else
    HOSTNAME="${COLLECTD_HOSTNAME:-$(hostname -f)}"
fi

while sleep "$INTERVAL"; do
    RX=`cat /sys/class/net/$1/statistics/rx_bytes`
    TX=`cat /sys/class/net/$1/statistics/tx_bytes`
    
    echo "PUTVAL $HOSTNAME/network-bandwidth-usage/if_octets interval=$INTERVAL N:$RX:$TX"
done

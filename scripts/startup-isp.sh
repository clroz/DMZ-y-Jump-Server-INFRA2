# Startup script del nodo ISP, extraído del archivo de topología PNETLab.
ip link set eth3 up
dhclient -nw -lf /var/lib/dhcp/dhclient-eth3.leases eth3
sleep 8
sysctl -w net.ipv4.ip_forward=1
if ! command -v iptables >/dev/null 2>&1; then export DEBIAN_FRONTEND=noninteractive; apt-get update -qq && apt-get install -y -qq iptables; fi
iptables -C FORWARD -i eth2 -o eth3 -s 198.51.100.44/30 -m conntrack --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT 2>/dev/null || iptables -A FORWARD -i eth2 -o eth3 -s 198.51.100.44/30 -m conntrack --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -C FORWARD -i eth3 -o eth2 -d 198.51.100.44/30 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT 2>/dev/null || iptables -A FORWARD -i eth3 -o eth2 -d 198.51.100.44/30 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -t nat -C POSTROUTING -s 198.51.100.44/30 -o eth3 -j MASQUERADE 2>/dev/null || iptables -t nat -A POSTROUTING -s 198.51.100.44/30 -o eth3 -j MASQUERADE

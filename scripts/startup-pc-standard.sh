# Startup script del nodo PC-STANDARD, extraído del archivo de topología PNETLab.
ip link set eth1 up
ip link add link eth1 name eth1.10 type vlan id 10
ip link set eth1.10 up
timeout 20 dhclient -1 -lf /var/lib/dhcp/dhclient-PC-STANDARD.leases eth1.10

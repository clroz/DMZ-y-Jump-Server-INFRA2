set -eu
cb=/tmp/infra2-chrome-client-build
rb=/tmp/infra2-red-router-build
mkdir -p "$cb" "$rb"
cat >"$cb/Dockerfile" <<'DOCKER'
FROM pnetlab/pnet-chrome:latest
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends iproute2 isc-dhcp-client openssh-client && apt-get clean && rm -rf /var/lib/apt/lists/*
DOCKER
cat >"$rb/Dockerfile" <<'DOCKER'
FROM pnetlab/ubuntu-router-ipsec-infra2:1745
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends dnsmasq && apt-get clean && rm -rf /var/lib/apt/lists/*
COPY start.sh /home/start.sh
COPY ipsec.conf /etc/ipsec.conf
COPY dnsmasq.conf /etc/infra2-dnsmasq.conf
RUN chmod 755 /home/start.sh
DOCKER
cat >"$rb/start.sh" <<'START'
#!/bin/bash
set -eu
service xinetd restart || true
service ssh restart || true
sysctl -w net.ipv4.ip_forward=1
for n in $(seq 1 60); do
  if ip -4 addr show dev eth1 2>/dev/null | grep -q '203.0.113.17/' && ip link show eth2 >/dev/null 2>&1; then break; fi
  sleep 1
done
modprobe 8021q 2>/dev/null || true
ip link add link eth2 name eth2.10 type vlan id 10 2>/dev/null || true
ip addr flush dev eth2.10 || true
ip addr add 10.17.45.1/25 dev eth2.10
ip link set eth2.10 up
ip route replace default via 203.0.113.18 dev eth1
dnsmasq --conf-file=/etc/infra2-dnsmasq.conf --pid-file=/run/infra2-dnsmasq.pid
iptables -F FORWARD
iptables -P FORWARD DROP
iptables -A FORWARD -i eth2.10 -o eth1 -s 10.17.45.10/32 -d 10.17.45.138/32 -p tcp --dport 22 -j REJECT
iptables -A FORWARD -i eth2.10 -o eth1 -s 10.17.45.10/32 -d 10.17.45.138/32 -p tcp --dport 443 -j ACCEPT
iptables -A FORWARD -i eth2.10 -o eth1 -s 10.17.45.11/32 -d 10.17.45.138/32 -p tcp -m multiport --dports 22,443,3389 -j ACCEPT
iptables -A FORWARD -i eth1 -o eth2.10 -s 10.17.45.138/32 -d 10.17.45.0/25 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
ipsec start
exec "$@"
START
cat >"$rb/ipsec.conf" <<'IPSEC'
config setup
    uniqueids=no
conn infra2-users
    auto=start
    keyexchange=ikev2
    type=tunnel
    authby=psk
    left=203.0.113.17
    leftid=203.0.113.17
    leftsubnet=10.17.45.0/25
    right=198.51.100.46
    rightid=198.51.100.46
    rightsubnet=10.17.45.138/32
    ike=des-sha512-modp2048!
    esp=des-sha512-modp2048!
    keyingtries=%forever
    dpdaction=restart
    dpddelay=30s
IPSEC
cat >"$rb/dnsmasq.conf" <<'DNS'
port=53
bind-interfaces
interface=eth2.10
dhcp-authoritative
dhcp-range=10.17.45.20,10.17.45.100,255.255.255.128,12h
dhcp-host=50:00:00:20:00:01,10.17.45.10,PC-STANDARD,infinite
dhcp-host=50:00:00:22:00:01,10.17.45.11,PC-PRIVILEGED,infinite
dhcp-option=option:router,10.17.45.1
dhcp-option=option:dns-server,10.17.45.1
address=/jump.infra2.lab/10.17.45.138
DNS
nohup docker build --network=host -t pnetlab/infra2-chrome-client:1745 "$cb" >/tmp/infra2-chrome-build.log 2>&1 &
echo $! >/tmp/infra2-chrome-build.pid
nohup docker build --network=host -t pnetlab/infra2-red-router:1745 "$rb" >/tmp/infra2-router-build.log 2>&1 &
echo $! >/tmp/infra2-router-build.pid
echo 'Started user-client and RED DEVICE image builds.'

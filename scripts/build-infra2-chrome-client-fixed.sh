set -eu
b=/tmp/infra2-chrome-client-build
cat >"$b/Dockerfile" <<'DOCKER'
FROM pnetlab/pnet-chrome:latest
RUN find /etc/apt/sources.list.d -maxdepth 1 -type f -iname '*google*' -delete; apt-get update; DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends iproute2 isc-dhcp-client openssh-client; apt-get clean; rm -rf /var/lib/apt/lists/*
DOCKER
nohup docker build --network=host -t pnetlab/infra2-chrome-client:1745 "$b" >/tmp/infra2-chrome-build.log 2>&1 &
echo $! >/tmp/infra2-chrome-build.pid
echo 'Rebuilt Chrome image without the obsolete Google apt feed.'

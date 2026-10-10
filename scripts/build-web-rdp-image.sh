set -eu
docker commit docker33 pnetlab/infra2-web-base:1745 >/dev/null
b=/tmp/infra2-web-rdp-build
mkdir -p "$b"
cat > "$b/Dockerfile" <<'DOCKER'
FROM pnetlab/infra2-web-base:1745
RUN set -eux; printf '#!/bin/sh\nexit 101\n' > /usr/sbin/policy-rc.d; chmod 755 /usr/sbin/policy-rc.d; apt-get update; DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends xrdp xorgxrdp xfce4-session xfce4-panel xfwm4 xfdesktop4 dbus-x11 xauth x11-xserver-utils; rm -f /usr/sbin/policy-rc.d; printf '#!/bin/sh\n. /etc/profile\nexec startxfce4\n' > /etc/xrdp/startwm.sh; chmod 755 /etc/xrdp/startwm.sh; apt-get clean; rm -rf /var/lib/apt/lists/*
COPY start.sh /home/start.sh
RUN chmod 755 /home/start.sh
DOCKER
cat > "$b/start.sh" <<'START'
#!/bin/bash
service xinetd restart || true
service ssh restart || true
service apache2 start
service xrdp-sesman start
service xrdp start
exec "$@"
START
nohup docker build --network=host -t pnetlab/infra2-web-rdp:1745 "$b" >/tmp/infra2-web-rdp-build.log 2>&1 &
echo $! >/tmp/infra2-web-rdp-build.pid
echo 'Web RDP image build started in isolated image build context.'
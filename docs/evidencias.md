# Evidencias de la práctica

Las imágenes de esta carpeta son capturas originales realizadas durante la comprobación del laboratorio. No se generaron diagramas ni se alteró el contenido de las capturas.

## Topología

![Topología PNETLab](evidencias/topologia-pnetlab.png)

## DHCP y acceso de clientes

| Comprobación | Evidencia |
|---|---|
| Lease DHCP PC-STANDARD: `10.17.45.10/25`, gateway `10.17.45.1` | ![Lease DHCP de PC-STANDARD](evidencias/dhcp-pc-standard.png) |
| Lease DHCP PC-PRIVILEGED: `10.17.45.11/25`, gateway `10.17.45.1` | ![Lease DHCP de PC-PRIVILEGED](evidencias/dhcp-pc-privileged.png) |
| PC-STANDARD → Jump por HTTPS: `HTTP 200` | ![HTTPS desde Standard al Jump](evidencias/acceso-standard-https-jump.png) |
| PC-STANDARD → Jump por SSH: conexión rechazada | ![SSH denegado para Standard](evidencias/denegacion-standard-ssh-jump.png) |
| PC-PRIVILEGED → Jump por HTTPS: `HTTP 200` | ![HTTPS desde Privileged al Jump](evidencias/acceso-privileged-https-jump.png) |
| PC-PRIVILEGED → Jump por RDP: TCP 3389 conectado | ![RDP desde Privileged al Jump](evidencias/acceso-privileged-rdp-jump.png) |
| PC-PRIVILEGED → Web directo: timeout | ![Acceso directo de cliente al Web bloqueado](evidencias/bloqueo-cliente-directo-web.png) |

## VPN y reglas del FortiGate

| Comprobación | Evidencia |
|---|---|
| Túnel `INFRA2-S2S` en estado Up | ![Estado del túnel VPN](evidencias/vpn-estado-up.png) |
| Selector Phase 2: Jump `/32` y VLAN 10 `/25` | ![Selector Phase 2](evidencias/vpn-phase2-selectores.png) |
| Políticas de firewall para usuarios, servidores y salida | ![Políticas del FortiGate](evidencias/fortigate-politicas.png) |
| Regla Jump → Web: HTTPS, RDP y SSH; ACCEPT; NAT deshabilitado | ![Regla requerida Jump a Web](evidencias/fortigate-regla-jump-web.png) |
| Registro de tráfico del FortiGate | ![Forward Traffic del FortiGate](evidencias/fortigate-forward-traffic.png) |

## Jump Server → Web Server

| Puerto | Servicio | Resultado |
|---:|---|---|
| 443 | HTTPS | TCP accesible |
| 3389 | RDP | TCP accesible |
| 22 | SSH | TCP accesible |

![Pruebas de puertos HTTPS y RDP desde Jump](evidencias/jump-web-https-rdp.png)

![Prueba de SSH desde Jump](evidencias/jump-web-ssh.png)

## RemoteApp

Al iniciar RemoteApp se mostró una advertencia de confianza del certificado de la puerta de enlace. Esta captura documenta el aviso observado durante la práctica.

![Advertencia de certificado RemoteApp Gateway](evidencias/aviso-certificado-gateway.png)

La configuración final de los grupos y de PuTTY/RDP se confirmó en la consola del servidor durante la sesión de práctica. No se conserva una captura posterior de esa lista en el conjunto de evidencias disponible.

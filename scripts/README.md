# Scripts del laboratorio

Esta carpeta reúne scripts presentes en la topología final, scripts de construcción de las imágenes personalizadas y comprobaciones de solo lectura.

| Archivo | Uso |
|---|---|
| `startup-isp.sh` | Inicializa interfaces, rutas, forwarding, NAT y DHCP del nodo ISP. Se extrajo de `config_data` del `.unl`. |
| `startup-pc-standard.sh` | Prepara VLAN 10 y solicita DHCP para PC-STANDARD. Se extrajo del `.unl`. |
| `startup-pc-privileged.sh` | Prepara VLAN 10 y solicita DHCP para PC-PRIVILEGED. Se extrajo del `.unl`. |
| `build-infra2-client-router-images.sh` | Construye las imágenes del cliente Chrome y RED DEVICE. Requiere la imagen base `pnetlab/ubuntu-router-ipsec-infra2:1745`. |
| `build-infra2-chrome-client-fixed.sh` | Reconstruye la imagen del cliente sin el repositorio APT de Google obsoleto. Requiere `pnetlab/pnet-chrome:latest`. |
| `build-web-rdp-image.sh` | Construye la imagen Web/RDP a partir del contenedor existente `docker33`; no es una construcción limpia independiente. |
| `validar-cliente-linux.sh` | Comprueba HTTPS al Jump, el bloqueo SSH de Standard y el bloqueo de acceso directo al Web Server. No cambia configuración. |
| `Validar-Puertos-Web.ps1` | Comprueba desde Jump la conectividad TCP al Web Server por 443, 3389 y 22. No cambia configuración. |

Los scripts `build-*` crean imágenes Docker y modifican el catálogo de imágenes del host PNETLab al ejecutarse. Las imágenes base indicadas deben estar disponibles primero. El `.unl` permite cargar la topología cuando las imágenes referenciadas ya existen; no ejecuta estos scripts automáticamente.

Las configuraciones capturadas del estado actual están en [`../running-configs/`](../running-configs/). Los comandos de verificación y sus resultados esperados están en [`../docs/validacion.md`](../docs/validacion.md).

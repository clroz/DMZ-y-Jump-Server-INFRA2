# Configuraciones en ejecución

Estas capturas se obtuvieron del laboratorio activo **DMZ y Jump Server INFRA2** en PNETLab el 10 de octubre de 2026. Las configuraciones representan el estado observado durante la extracción; no son una plantilla para producción.

| Archivo | Equipo | Contenido |
|---|---|---|
| [`FORTIGATE.txt`](FORTIGATE.txt) | FortiGate | Secciones de configuración activas: interfaces, rutas estáticas, objetos y grupos de direcciones, servicios personalizados, políticas y túnel IPsec. |
| [`RED-DEVICE.txt`](RED-DEVICE.txt) | RED DEVICE | Interfaces, rutas, forwarding IPv4 y reglas activas de `iptables`. |
| [`ISP.txt`](ISP.txt) | ISP | Interfaces, rutas, forwarding IPv4 y reglas activas de `iptables`. |
| [`WEB-SERVER.txt`](WEB-SERVER.txt) | WEB-SERVER | Interfaces, rutas y servicios TCP en escucha. |
| [`PC-STANDARD.txt`](PC-STANDARD.txt) | PC-STANDARD | Interfaces, rutas y lease DHCP observado. |
| [`PC-PRIVILEGED.txt`](PC-PRIVILEGED.txt) | PC-PRIVILEGED | Interfaces, rutas y lease DHCP observado. |

La configuración del FortiGate se consultó con comandos `show` de solo lectura. Se redactó el valor de la clave precompartida de IPsec. No se guardaron contraseñas ni claves en el repositorio.

El archivo de topología [`../lab/DMZ y Jump Server INFRA2.unl`](../lab/DMZ%20y%20Jump%20Server%20INFRA2.unl) conserva la definición de los siete nodos y los scripts de arranque que PNETLab ejecuta para ISP y clientes. Sus scripts también están extraídos en [`../scripts/`](../scripts/).

La VM Windows Server está representada en el archivo `.unl` y documentada en el README y las evidencias. No se obtuvo una exportación textual de su configuración interna de Windows durante esta captura; por eso no se presenta una como si fuera un *running-config* de red.

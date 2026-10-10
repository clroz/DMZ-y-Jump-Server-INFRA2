# Procedimiento de validación

Comandos de consulta usados para reproducir las pruebas documentadas. Ejecútalos en las terminales indicadas. No cambian la configuración. La gestión del FortiGate se comprueba exclusivamente desde su interfaz gráfica, como exige la práctica.

Se incluyen versiones ejecutables de las comprobaciones de clientes y de puertos en [`scripts/`](../scripts/). Son scripts de validación de solo lectura; no configuran equipos ni contienen credenciales.

Desde la raíz del repositorio, en cada cliente Linux ejecuta `bash scripts/validar-cliente-linux.sh standard` o `bash scripts/validar-cliente-linux.sh privileged`, según corresponda. En el Jump Server, ejecuta `powershell -ExecutionPolicy Bypass -File scripts/Validar-Puertos-Web.ps1`.

## DHCP — PC-STANDARD y PC-PRIVILEGED

En cada terminal Linux:

```bash
cat /var/lib/dhcp/dhclient-eth1.10.leases
```

Resultados esperados: Standard `10.17.45.10/25`; Privileged `10.17.45.11/25`; gateway y DHCP `10.17.45.1`.

## PC-STANDARD — Jump permitido, SSH denegado, Web directo denegado

En PC-STANDARD:

```bash
curl -k --connect-timeout 3 -o /dev/null -w "HTTP %{http_code}\n" https://10.17.45.138
ssh -o ConnectTimeout=3 admin@10.17.45.138
curl -k --connect-timeout 3 -o /dev/null -w "HTTP %{http_code}\n" https://10.17.45.130
```

Esperado: HTTPS al Jump responde `HTTP 200`; SSH al Jump se rechaza; HTTPS directo al Web Server agota el tiempo de espera.

## PC-PRIVILEGED — Jump permitido, RDP disponible, Web directo denegado

En PC-PRIVILEGED:

```bash
curl -k --connect-timeout 3 -o /dev/null -w "HTTP %{http_code}\n" https://10.17.45.138
timeout 3 bash -c '</dev/tcp/10.17.45.138/3389' && echo "RDP accesible" || echo "RDP bloqueado"
curl -k --connect-timeout 3 -o /dev/null -w "HTTP %{http_code}\n" https://10.17.45.130
```

Esperado: HTTPS al Jump responde `HTTP 200`; TCP 3389 al Jump es accesible; HTTPS directo al Web Server agota el tiempo de espera.

## Jump Server — puertos requeridos al Web Server

En PowerShell del Jump Server:

```powershell
Test-NetConnection 10.17.45.130 -Port 443
Test-NetConnection 10.17.45.130 -Port 3389
Test-NetConnection 10.17.45.130 -Port 22
```

Esperado en cada prueba: `TcpTestSucceeded : True`.

## Active Directory y RemoteApp

En PowerShell del servidor unido al dominio, con el módulo de Active Directory disponible:

```powershell
Get-ADGroupMember "RDS-WEB" | Select Name,SamAccountName
Get-ADGroupMember "RDS-PRIVILEGED" | Select Name,SamAccountName
```

Esperado: `standard` y `privileged` en `RDS-WEB`; solo `privileged` en `RDS-PRIVILEGED`.

Para consultar las aplicaciones publicadas en la colección RDS:

```powershell
Get-RDRemoteApp -CollectionName "QuickSessionCollection" |
    Format-List DisplayName,Alias,UserGroups,ShowInWebAccess
```

Asignación esperada: Edge para `RDS-WEB`; PuTTY y Conexión a Escritorio remoto para `RDS-PRIVILEGED`. El usuario privilegiado pertenece a ambos grupos.

## FortiGate — comprobación obligatoria por GUI

No se incluyen comandos FortiGate para configuración o demostración. En la GUI:

1. En **VPN → IPsec Tunnels**, confirmar `INFRA2-S2S` en estado **Up**.
2. Editar el túnel y mostrar el selector Phase 2: local `10.17.45.138/32`; remoto `10.17.45.0/25`.
3. En **Policy & Objects → Firewall Policy**, revisar las reglas `DENY_VLAN10_DIRECT_TO_WEB`, `DENY_STANDARD_SSH_TO_JUMP`, `ALLOW_STANDARD_HTTPS_TO_JUMP`, `ALLOW_PRIVILEGED_SERVICES_TO_JUMP` y `ALLOW_JUMP_TO_WEB_REQUIRED`.
4. Abrir `ALLOW_JUMP_TO_WEB_REQUIRED` y mostrar HTTPS, RDP y SSH, acción ACCEPT y NAT deshabilitado.
5. En **Log & Report → Forward Traffic**, localizar una sesión Jump `10.17.45.138` → Web `10.17.45.130` asociada a esa política.

## Lanzamiento RemoteApp

Iniciar sesión en RD Web como `INFRA2\standard` y confirmar que aparece Edge. Iniciar como `INFRA2\privileged` y confirmar Edge, PuTTY y Conexión a Escritorio remoto. Al lanzar una aplicación puede aparecer el aviso del certificado del RD Gateway `WIN-1S9GHPAT5RF.infra2.lab`; es una limitación observada en este laboratorio.

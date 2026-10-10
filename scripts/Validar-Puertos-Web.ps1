# Pruebas TCP de solo lectura para ejecutar en el Jump Server.
$webServer = '10.17.45.130'
$ports = @(
    @{ Port = 443; Service = 'HTTPS' },
    @{ Port = 3389; Service = 'RDP' },
    @{ Port = 22; Service = 'SSH' }
)

foreach ($item in $ports) {
    Write-Host "Probando $($item.Service) TCP/$($item.Port) en $webServer"
    Test-NetConnection $webServer -Port $item.Port |
        Select-Object ComputerName, RemotePort, TcpTestSucceeded
}

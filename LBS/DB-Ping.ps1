#Thank to sir GPT
$remoteHost = "IP"
$remotePort = 4900 # Change this to the desired port

$startTime = Get-Date
$tcpClient = New-Object System.Net.Sockets.TcpClient

try {
    $tcpClient.Connect($remoteHost, $remotePort)
    $endTime = Get-Date
    $timeTaken = ($endTime - $startTime).TotalMilliseconds
    Write-Host "Connected to $remoteHost on port $remotePort in $timeTaken ms"
} catch {
    Write-Host "Failed to connect to $remoteHost on port $remotePort"
} finally {
    $tcpClient.Close()
}

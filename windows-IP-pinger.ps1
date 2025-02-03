param(
    [Parameter(Mandatory=$true)]
    [string]$FilePath
)

# Function to validate IP address format
function Test-IPAddress {
    param([string]$IP)
    $IPRegex = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
    return $IP -match $IPRegex
}

# Check if file exists
if (-not (Test-Path $FilePath)) {
    Write-Host "Error: File not found at path: $FilePath" -ForegroundColor Red
    exit
}

# Read the file content
$fileContent = Get-Content -Path $FilePath -Raw

# Split the content (handles both comma and newline separation)
$IPs = $fileContent -split '[,\r\n]+' | Where-Object { $_ -match '\S' } | ForEach-Object { $_.Trim() }

# Create arrays to store results
$results = @()

Write-Host "`nStarting IP status check..." -ForegroundColor Cyan

foreach ($IP in $IPs) {
    if (-not (Test-IPAddress $IP)) {
        Write-Host "Invalid IP format: $IP" -ForegroundColor Yellow
        continue
    }

    $result = @{
        'IP' = $IP
        'Status' = $null
        'ResponseTime' = $null
    }

    try {
        $ping = Test-Connection -ComputerName $IP -Count 1 -ErrorAction Stop
        $result.Status = 'Up'
        $result.ResponseTime = "$($ping.ResponseTime)ms"
        Write-Host "IP: $IP - Status: Up (Response Time: $($ping.ResponseTime)ms)" -ForegroundColor Green
    }
    catch {
        $result.Status = 'Down'
        $result.ResponseTime = 'N/A'
        Write-Host "IP: $IP - Status: Down" -ForegroundColor Red
    }

    $results += [PSCustomObject]$result
}

# Export results to CSV
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$outputPath = "IPStatus_$timestamp.csv"
$results | Export-Csv -Path $outputPath -NoTypeInformation

Write-Host "`nScan completed! Results exported to: $outputPath" -ForegroundColor Cyan
Write-Host "Summary:"
Write-Host "Total IPs checked: $($results.Count)"
Write-Host "Up: $(($results | Where-Object { $_.Status -eq 'Up' }).Count)"
Write-Host "Down: $(($results | Where-Object { $_.Status -eq 'Down' }).Count)"


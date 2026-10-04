param(
    [int]$Port = 8088,
    [string]$Php = 'D:\phpstudy_pro\Extensions\php\php7.3.4nts\php.exe'
)

$ErrorActionPreference = 'Stop'
$serverDir = $PSScriptRoot
$publicDir = Join-Path $serverDir 'public'
$router = Join-Path $publicDir 'index.php'
$logDir = Join-Path $serverDir 'logs'
$pidFile = Join-Path $serverDir 'online-tunnel.pid'
$urlFile = Join-Path $serverDir 'online-url.txt'
$outLog = Join-Path $logDir 'tunnel.out.log'
$errLog = Join-Path $logDir 'tunnel.err.log'

New-Item -ItemType Directory -Path $logDir -Force | Out-Null

if (Test-Path -LiteralPath $pidFile) {
    $existingPid = [int](Get-Content -LiteralPath $pidFile -Raw)
    $existing = Get-Process -Id $existingPid -ErrorAction SilentlyContinue
    if ($existing) {
        $existingUrl = if (Test-Path -LiteralPath $urlFile) { Get-Content -LiteralPath $urlFile -Raw } else { 'PID ' + $existingPid }
        Write-Host "Online tunnel already running: $existingUrl"
        exit 0
    }
}

$apiReady = $false
try {
    $health = Invoke-RestMethod -Uri "http://127.0.0.1:$Port/api/health" -TimeoutSec 2
    $apiReady = $health.ok -eq $true
} catch {
    $apiReady = $false
}

if (-not $apiReady) {
    Start-Process -FilePath $Php -ArgumentList @('-S', "127.0.0.1:$Port", '-t', $publicDir, $router) -WorkingDirectory $publicDir -WindowStyle Hidden | Out-Null
    Start-Sleep -Seconds 1
}

$npxCommand = Get-Command npx.cmd -ErrorAction SilentlyContinue
if (-not $npxCommand) {
    throw 'npx.cmd not found. Please install Node.js first.'
}

if (Test-Path -LiteralPath $outLog) { [System.IO.File]::WriteAllText($outLog, '') }
if (Test-Path -LiteralPath $errLog) { [System.IO.File]::WriteAllText($errLog, '') }

$tunnel = Start-Process -FilePath $npxCommand.Source -ArgumentList @('--yes', 'localtunnel', '--port', "$Port") -WorkingDirectory $serverDir -WindowStyle Hidden -RedirectStandardOutput $outLog -RedirectStandardError $errLog -PassThru
Set-Content -LiteralPath $pidFile -Value $tunnel.Id -Encoding ascii

$publicUrl = $null
for ($i = 0; $i -lt 80; $i++) {
    Start-Sleep -Milliseconds 500
    if (Test-Path -LiteralPath $outLog) {
        $text = Get-Content -LiteralPath $outLog -Raw -ErrorAction SilentlyContinue
        if (-not [string]::IsNullOrWhiteSpace($text)) {
            $match = [regex]::Match($text, 'https://[a-zA-Z0-9-]+\.loca\.lt')
            if ($match.Success) {
                $publicUrl = $match.Value
                break
            }
        }
    }
    if ($tunnel.HasExited) {
        break
    }
}

if (-not $publicUrl) {
    if (Test-Path -LiteralPath $errLog) {
        Get-Content -LiteralPath $errLog
    }
    throw 'Failed to create the public URL.'
}

Set-Content -LiteralPath $urlFile -Value $publicUrl -Encoding utf8
Write-Host "APP public URL: $publicUrl"
Write-Host "API health: $publicUrl/api/health"
param(
    [string]$Listen = '127.0.0.1',
    [int]$Port = 8088
)

$ErrorActionPreference = 'Stop'

$phpCommand = Get-Command php -ErrorAction SilentlyContinue
if ($phpCommand) {
    $php = $phpCommand.Source
} else {
    $php = 'D:\phpstudy_pro\Extensions\php\php7.3.4nts\php.exe'
}

if (-not (Test-Path -LiteralPath $php)) {
    throw "PHP executable not found. Set the php command in PATH or update this script."
}

Write-Host "API: http://${Listen}:$Port"
Write-Host "Health: http://${Listen}:$Port/api/health"
& $php -S "${Listen}:$Port" -t (Join-Path $PSScriptRoot 'public') (Join-Path $PSScriptRoot 'public\index.php')
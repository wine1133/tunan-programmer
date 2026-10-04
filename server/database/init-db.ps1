param(
    [string]$Mysql = 'mysql',
    [string]$User = 'root',
    [string]$Password = 'root'
)

$ErrorActionPreference = 'Stop'
$source = Join-Path $PSScriptRoot 'init.sql'
$temp = Join-Path $env:TEMP 'itbaizhan-init.sql'

Copy-Item -LiteralPath $source -Destination $temp -Force
& $Mysql "-u$User" "-p$Password" --default-character-set=utf8mb4 -e "source $temp"

if ($LASTEXITCODE -ne 0) {
    throw "Database initialization failed."
}

Write-Host 'Database itbaizhan initialized.'
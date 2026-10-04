param(
    [string]$Repo = 'wine1133/tunan-programmer',
    [string]$Branch = 'main'
)

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

& (Join-Path $PSScriptRoot 'start-online.ps1')

$publicUrlPath = Join-Path $PSScriptRoot 'online-url.txt'
if (-not (Test-Path -LiteralPath $publicUrlPath)) {
    throw 'Public URL was not created.'
}
$publicUrl = (Get-Content -LiteralPath $publicUrlPath -Raw).Trim()
$configPath = Join-Path $projectRoot 'docs\api-config.js'
[System.IO.File]::WriteAllText($configPath, "window.__TU_NAN_API_BASE__ = '$publicUrl';`r`n", [System.Text.UTF8Encoding]::new($false))

if (-not (Test-Path -LiteralPath (Join-Path $projectRoot '.git'))) {
    git init -b $Branch
}

$currentName = git config user.name
if (-not $currentName) {
    git config user.name 'wine1133'
}
$currentEmail = git config user.email
if (-not $currentEmail) {
    git config user.email 'wine1133@users.noreply.github.com'
}

git add -A
git diff --cached --quiet
if ($LASTEXITCODE -ne 0) {
    git commit -m 'Publish Tunan Programmer app'
} else {
    Write-Host 'No local changes to commit.'
}

gh auth status *> $null
if ($LASTEXITCODE -ne 0) {
    throw 'GitHub login expired. Run: gh auth login --hostname github.com --git-protocol https --web'
}

$remote = git remote get-url origin 2>$null
if (-not $remote) {
    gh repo view $Repo *> $null
    if ($LASTEXITCODE -ne 0) {
        gh repo create $Repo --public --source . --remote origin --push
    } else {
        git remote add origin "https://github.com/$Repo.git"
        git push -u origin $Branch
    }
} else {
    git push -u origin $Branch
}

gh api --method POST "repos/$Repo/pages" -f "source[branch]=$Branch" -f 'source[path]=/docs' *> $null
if ($LASTEXITCODE -ne 0) {
    gh api --method PUT "repos/$Repo/pages" -f "source[branch]=$Branch" -f 'source[path]=/docs' *> $null
}

$parts = $Repo.Split('/')
$pagesUrl = "https://$($parts[0]).github.io/$($parts[1])/"
Write-Host "GitHub repository: https://github.com/$Repo"
Write-Host "GitHub Pages: $pagesUrl"
Write-Host "Live API: $publicUrl"
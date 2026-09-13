#!/usr/bin/env pwsh
param()

$bash = @(
    'C:\Program Files\Git\bin\bash.exe',
    'C:\Program Files\Git\usr\bin\bash.exe',
    '/bin/bash',
    '/usr/bin/bash'
)

foreach ($candidate in $bash) {
    if (Test-Path $candidate) {
        & $candidate scripts/bootstrap.sh
        exit $LASTEXITCODE
    }
}

Write-Host 'bash was not found in the current environment. Install Git Bash or use a Linux shell for fishOS scripts.'
exit 1

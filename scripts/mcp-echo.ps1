$packageRoot = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Packages\OpenJS.NodeJS.LTS_Microsoft.Winget.Source_8wekyb3d8bbwe'
$nodeInstall = Get-ChildItem -Path $packageRoot -Directory -Filter 'node-v*-win-x64' |
    Sort-Object Name -Descending |
    Select-Object -First 1

if (-not $nodeInstall) {
    [Console]::Error.WriteLine('A WinGet Node.js installation was not found.')
    exit 1
}

$nodeExecutable = Join-Path $nodeInstall.FullName 'node.exe'
$serverScript = Join-Path $PSScriptRoot 'mcp-echo.mjs'
& $nodeExecutable $serverScript
exit $LASTEXITCODE
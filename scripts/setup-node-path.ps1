$packageRoot = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Packages\OpenJS.NodeJS.LTS_Microsoft.Winget.Source_8wekyb3d8bbwe'
$nodeInstall = Get-ChildItem -Path $packageRoot -Directory -Filter 'node-v*-win-x64' |
    Sort-Object Name -Descending |
    Select-Object -First 1

if (-not $nodeInstall) {
    throw 'A WinGet Node.js installation was not found.'
}

$nodeDirectory = $nodeInstall.FullName
$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
$pathEntries = @($userPath -split ';' | Where-Object { $_ -and $_ -ne $nodeDirectory })
$pathEntries += $nodeDirectory
[Environment]::SetEnvironmentVariable('Path', ($pathEntries -join ';'), 'User')
$env:Path = "$nodeDirectory;$env:Path"

& (Join-Path $nodeDirectory 'node.exe') --version
& (Join-Path $nodeDirectory 'npm.cmd') --version
Write-Output 'Node.js was added to the user PATH. Restart VS Code to update existing terminals.'

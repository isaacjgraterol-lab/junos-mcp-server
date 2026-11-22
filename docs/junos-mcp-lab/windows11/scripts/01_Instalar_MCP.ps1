# Windows 11 + PowerShell 5.1+: external installer for the official Juniper MCP server.
# This script never configures network devices. Community lab helper, not a Juniper product.
[CmdletBinding()]
param(
    [string]$BaseDir = (Join-Path $env:USERPROFILE 'Py_Modules'),
    [string]$Commit = '75fe90afd7a0566f8c9e4c88099309aa12dee6e6'
)
$ErrorActionPreference = 'Stop'
foreach ($program in @('git', 'py', 'code')) {
    if (-not (Get-Command $program -ErrorAction SilentlyContinue)) {
        throw "Missing $program in PATH. Install Git, Python 3.11 and VS Code, then reopen PowerShell."
    }
}
& py -3.11 --version
if ($LASTEXITCODE -ne 0) { throw 'Python 3.11 is missing.' }
$server = Join-Path $BaseDir 'junos-mcp-server'
$private = Join-Path $BaseDir 'MCP_LAB_PRIVATE'
$workspace = Join-Path $BaseDir 'MCP_LAB_TOOLS'
New-Item -ItemType Directory -Force -Path $BaseDir,$private,$workspace,(Join-Path $workspace '.vscode') | Out-Null
if (-not (Test-Path $server)) {
    & git clone https://github.com/Juniper/junos-mcp-server.git $server
    if ($LASTEXITCODE -ne 0) { throw 'git clone failed.' }
    & git -C $server checkout --detach $Commit
    if ($LASTEXITCODE -ne 0) { throw 'Could not check out the documented commit.' }
} else {
    if (-not (Test-Path (Join-Path $server 'jmcp.py'))) { throw "Directory $server exists without jmcp.py." }
    $head = (& git -C $server rev-parse HEAD).Trim()
    if ($head -ne $Commit) { Write-Warning "Existing checkout is at $head; documented lab version is $Commit. Leaving it unchanged." }
}
$python = Join-Path $server '.venv\Scripts\python.exe'
if (-not (Test-Path $python)) {
    & py -3.11 -m venv (Join-Path $server '.venv')
    if ($LASTEXITCODE -ne 0) { throw 'Could not create virtual environment.' }
}
& $python -m pip install --upgrade pip
if ($LASTEXITCODE -ne 0) { throw 'pip upgrade failed.' }
& $python -m pip install -r (Join-Path $server 'requirements.txt')
if ($LASTEXITCODE -ne 0) { throw 'Installation of requirements failed.' }
& $python -m pip check
if ($LASTEXITCODE -ne 0) { throw 'pip check failed.' }
& $python -c 'import jnpr.junos, mcp, ncclient, paramiko; print("Dependencies OK")'
if ($LASTEXITCODE -ne 0) { throw 'Python import validation failed.' }
$config = @{ servers = @{ junos_official = @{
    type='stdio'; command=$python
    args=@((Join-Path $server 'jmcp.py'),'-f',(Join-Path $private 'devices.json'),'-t','stdio')
    cwd=$server
}}}
$dest = Join-Path $workspace '.vscode\mcp.json'
if (Test-Path $dest) { Copy-Item $dest "$dest.bak-$(Get-Date -Format 'yyyyMMdd-HHmmss')" }
[IO.File]::WriteAllText($dest,($config | ConvertTo-Json -Depth 12),[Text.UTF8Encoding]::new($false))
Write-Host "Local setup completed. No NETCONF connections or device changes were made."
Write-Host "Next: 02_Agregar_Router.ps1 (local private device inventory), then 03_Validar_NETCONF.ps1."
Write-Host "Open VS Code: code $workspace"

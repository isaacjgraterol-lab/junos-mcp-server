# Create one private device entry for Junos MCP without putting a password in the command history.
# CAUTION: password authentication stores the password as plaintext in devices.json. Prefer SSH keys.
[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][ValidatePattern('^[A-Za-z0-9_-]+$')][string]$RouterAlias,
    [Parameter(Mandatory=$true)][string]$Address,
    [Parameter(Mandatory=$true)][string]$Username,
    [ValidateRange(1,65535)][int]$Port = 830,
    [ValidateSet('SSHKey','Password')][string]$AuthMode = 'SSHKey',
    [string]$PrivateKeyPath,
    [string]$BaseDir = (Join-Path $env:USERPROFILE 'Py_Modules')
)
$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($Address) -or [string]::IsNullOrWhiteSpace($Username)) { throw 'Address and Username cannot be blank.' }
$private = Join-Path $BaseDir 'MCP_LAB_PRIVATE'
New-Item -ItemType Directory -Force -Path $private | Out-Null
$path = Join-Path $private 'devices.json'
if (Test-Path $path) {
    $devices = Get-Content $path -Raw | ConvertFrom-Json
} else {
    $devices = [pscustomobject]@{}
}
if ($devices.PSObject.Properties[$RouterAlias]) { throw "Alias $RouterAlias already exists. No changes made." }
if ($AuthMode -eq 'SSHKey') {
    if (-not $PrivateKeyPath -or -not (Test-Path $PrivateKeyPath)) { throw 'Use -PrivateKeyPath with a valid local key when AuthMode is SSHKey.' }
    $auth = @{ type='ssh_key'; private_key_path=(Resolve-Path $PrivateKeyPath).Path }
} else {
    $secret = Read-Host 'NETCONF password (hidden; will be saved in plaintext locally)' -AsSecureString
    if ($secret.Length -eq 0) { throw 'Password cannot be blank.' }
    $ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secret)
    try { $plain = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr) }
    finally { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr) }
    $auth = @{ type='password'; password=$plain }
}
if (Test-Path $path) { Copy-Item $path "$path.bak-$(Get-Date -Format 'yyyyMMdd-HHmmss')" }
$entry = @{ ip=$Address; port=$Port; username=$Username; auth=$auth }
$devices | Add-Member -NotePropertyName $RouterAlias -NotePropertyValue $entry
[IO.File]::WriteAllText($path,($devices | ConvertTo-Json -Depth 20),[Text.UTF8Encoding]::new($false))
Remove-Variable plain -ErrorAction SilentlyContinue
Write-Host "Saved $RouterAlias to private inventory. NEVER commit or attach devices.json to an AI chat."
Write-Host 'Restart junos_official in VS Code to reload the inventory.'

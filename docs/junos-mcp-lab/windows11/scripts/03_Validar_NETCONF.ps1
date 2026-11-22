# Verify a read-only Junos NETCONF RPC from a local private inventory entry.
# Outputs success/error class only. Does not display passwords, usernames or host addresses.
[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][string]$RouterAlias,
    [string]$BaseDir = (Join-Path $env:USERPROFILE 'Py_Modules')
)
$ErrorActionPreference = 'Stop'
$server = Join-Path $BaseDir 'junos-mcp-server'
$python = Join-Path $server '.venv\Scripts\python.exe'
$inventory = Join-Path $BaseDir 'MCP_LAB_PRIVATE\devices.json'
if (-not (Test-Path $python)) { throw 'Run 01_Instalar_MCP.ps1 first.' }
if (-not (Test-Path $inventory)) { throw 'Run 02_Agregar_Router.ps1 first.' }
$data = Get-Content $inventory -Raw | ConvertFrom-Json
$record = $data.PSObject.Properties[$RouterAlias]
if ($null -eq $record) { throw "Device alias $RouterAlias not found." }
$tcp = Test-NetConnection -ComputerName $record.Value.ip -Port $record.Value.port -InformationLevel Quiet
if (-not $tcp) { throw 'TCP/NETCONF port not reachable. Check route, service and firewall.' }
Write-Host 'TCP port: PASS'
$oldPythonPath = [Environment]::GetEnvironmentVariable('PYTHONPATH','Process')
$env:PYTHONPATH = $server
$env:JMCP_TEST_ALIAS = $RouterAlias
$env:JMCP_TEST_DEVICE_FILE = $inventory
try {
@'
import json, os
from pathlib import Path
from jnpr.junos import Device
from utils.config import prepare_connection_params
alias = os.environ["JMCP_TEST_ALIAS"]
devices = json.loads(Path(os.environ["JMCP_TEST_DEVICE_FILE"]).read_text(encoding="utf-8-sig"))
conn = prepare_connection_params(devices[alias], alias)
conn["timeout"] = 30
try:
    with Device(**conn) as device:
        reply = device.rpc.get_software_information()
        if reply is None:
            raise RuntimeError("Empty RPC response")
        print("NETCONF/PyEZ get-software-information: PASS")
except Exception as err:
    print("NETCONF/PyEZ: FAIL (" + type(err).__name__ + ")")
    raise SystemExit(1)
'@ | & $python -
    if ($LASTEXITCODE -ne 0) { throw 'NETCONF/PyEZ validation failed. Check private logs locally.' }
} finally {
    Remove-Item Env:JMCP_TEST_ALIAS -ErrorAction SilentlyContinue
    Remove-Item Env:JMCP_TEST_DEVICE_FILE -ErrorAction SilentlyContinue
    [Environment]::SetEnvironmentVariable('PYTHONPATH',$oldPythonPath,'Process')
}
Write-Host 'Read-only NETCONF check completed. Now start/restart junos_official in VS Code.'

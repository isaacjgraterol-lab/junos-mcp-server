# Windows 11 + GitHub Copilot + Junos MCP (guía reproducible)

**Origen:** adaptación comunitaria del laboratorio, **no** instalador oficial de Juniper. Referencia inmutable: commit `75fe90afd7a0566f8c9e4c88099309aa12dee6e6`.

## Prerrequisitos

- Windows 11, PowerShell, Git, Python 3.11, VS Code y acceso a GitHub Copilot (Agent).
- Router Junos autorizado con NETCONF/SSH (puerto habitual 830), cuenta de privilegios mínimos y conectividad.
- Comprobar políticas corporativas sobre enviar datos de red a IA.

```powershell
winget install --id Git.Git -e
winget install --id Python.Python.3.11 -e
winget install --id Microsoft.VisualStudioCode -e
```

Reabre PowerShell y valida `git --version`, `py -3.11 --version`, `code --version`.

## Instalación manual, paso a paso

```powershell
$root = "$env:USERPROFILE\Py_Modules"
New-Item -ItemType Directory -Force -Path $root | Out-Null
cd $root
git clone https://github.com/Juniper/junos-mcp-server.git
cd .\junos-mcp-server
git checkout --detach 75fe90afd7a0566f8c9e4c88099309aa12dee6e6
py -3.11 -m venv .venv
$python = '.\.venv\Scripts\python.exe'
& $python -m pip install --upgrade pip
& $python -m pip install -r requirements.txt
& $python -m pip check
& $python .\jmcp.py --help
```

## Inventario privado

Guardar en `$env:USERPROFILE\Py_Modules\MCP_LAB_PRIVATE\devices.json`, **fuera** del repositorio:

```json
{
  "LAB-RTR-01": {
    "ip": "192.0.2.10",
    "port": 830,
    "username": "netconf-readonly",
    "auth": { "type": "password", "password": "REEMPLAZAR_SOLO_EN_ARCHIVO_LOCAL" }
  }
}
```

La contraseña queda en texto claro en este esquema; es preferible usar clave SSH y controlar permisos locales. Nunca adjuntar el inventario a Copilot/ChatGPT ni a Git. `192.0.2.10` es una IP de documentación.

## Configuración MCP de VS Code

```powershell
$root = "$env:USERPROFILE\Py_Modules"
$repo = "$root\junos-mcp-server"
$workspace = "$root\MCP_LAB_TOOLS"
$private = "$root\MCP_LAB_PRIVATE"
New-Item -ItemType Directory -Force "$workspace\.vscode" | Out-Null
$config = @{ servers = @{ junos_official = @{
  type = 'stdio'
  command = "$repo\.venv\Scripts\python.exe"
  args = @("$repo\jmcp.py", '-f', "$private\devices.json", '-t', 'stdio')
  cwd = $repo
}}}
[IO.File]::WriteAllText("$workspace\.vscode\mcp.json",
  ($config | ConvertTo-Json -Depth 10), [Text.UTF8Encoding]::new($false))
code $workspace
```

En VS Code: **Ctrl+Shift+P → MCP: List Servers → junos_official → Start**. Esperar nueve herramientas en el commit del laboratorio. Para probar sin NETCONF: pedir a Copilot que invoque únicamente `get_router_list` y liste **solo alias**. Después, con permiso de lectura y aprobación explícita, usar `gather_device_facts` y `execute_junos_command` con `show version`.

## Resolución de problemas

| Síntoma | Comprobación |
| --- | --- |
| Python 3.11 no aparece | `py -0p` y reiniciar PowerShell |
| `code` no aparece | PATH de VS Code y nueva consola |
| MCP no inicia | revisar ruta venv, `jmcp.py`, `-f` y Output → MCP |
| Alias anteriores | archivo privado activo y reiniciar servidor |
| Puerto 830 inaccesible | TCP, ACL/firewall y servicio NETCONF |
| Autenticación falla | usuario, clave, permisos y RPC compatibles |

El comando `set system services netconf ssh` sería un **cambio de configuración Junos**; solo un administrador autorizado debe aplicarlo. Este procedimiento no ejecuta cambios en los routers.

## Automatización auxiliar

Un kit local de scripts PowerShell se preparó para reducir pasos repetitivos, pero **aún requiere validación en una instalación Windows 11 limpia**. Por eso el procedimiento manual anterior es la referencia pública reproducible hasta completar esas pruebas.

Fuente: https://github.com/Juniper/junos-mcp-server

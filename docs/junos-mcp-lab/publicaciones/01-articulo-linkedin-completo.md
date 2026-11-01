# De una pregunta al router: Junos MCP + Copilot en Windows 11

**Serie 1/3 · Laboratorio de Network Engineering y automatización · 1 de noviembre de 2026**

¿Y si en lugar de abrir múltiples terminales pudiéramos formular una consulta técnica en lenguaje natural y dejar que un asistente seleccionara una herramienta para interrogar un router real?

Me propuse validar esa idea usando **Windows 11**, **GitHub Copilot en VS Code** y el **servidor MCP oficial de Juniper**, trabajando con NETCONF y Juniper PyEZ en dispositivos de laboratorio.

No es una simulación ni un sistema que resuelve incidentes por sí solo. Es una prueba de concepto en la que la IA recibe resultados reales de dispositivos Junos y ayuda a organizar el análisis.

## Arquitectura: qué pasa detrás del prompt

**Usuario → GitHub Copilot (Agent) → MCP por STDIO → Juniper PyEZ → NETCONF/SSH → Junos**

MCP expone herramientas al asistente; **no descubre por sí solo todos los equipos de una red**. El servidor lee un inventario local al iniciarse, y las consultas NETCONF se realizan bajo demanda. Los datos de acceso permanecen en archivos privados fuera del repositorio, aunque el modelo puede recibir los datos que retornan las tools seleccionadas.

En la prueba local se descubrieron **9 tools**. Entre las utilizadas están:

- \`get_router_list\`: consulta el inventario, sin conectarse al router.
- \`gather_device_facts\`: obtiene características del equipo mediante PyEZ/NETCONF.
- \`execute_junos_command\`: ejecuta consultas CLI por NETCONF.
- \`execute_junos_command_batch\`: ejecuta el mismo comando en distintos routers.

El servidor también ofrece herramientas que pueden cambiar configuraciones. **Copilot Agent no constituye una garantía de solo lectura**: es necesario limitar permisos Junos, revisar las acciones y evitar autoaprobaciones.

## Paso a paso en Windows 11

Entorno documentado: Python **3.11.7** y VS Code **1.143.1**. El commit exacto del servidor probado fue **75fe90afd7a0566f8c9e4c88099309aa12dee6e6**.

En PowerShell instalé Git, Python y VS Code:

~~~powershell
winget install --id Git.Git -e
winget install --id Python.Python.3.11 -e
winget install --id Microsoft.VisualStudioCode -e
~~~

En una nueva terminal, preparé el proyecto y su entorno virtual:

~~~powershell
mkdir "$env:USERPROFILE\Py_Modules" -Force
cd "$env:USERPROFILE\Py_Modules"
git clone https://github.com/Juniper/junos-mcp-server.git
cd junos-mcp-server
git checkout --detach 75fe90afd7a0566f8c9e4c88099309aa12dee6e6
py -3.11 -m venv .venv
.\.venv\Scripts\python.exe -m pip install --upgrade pip
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
.\.venv\Scripts\python.exe -m pip check
~~~

Después preparé un \`devices.json\` **privado fuera del repositorio** y configuré VS Code para iniciar \`jmcp.py -f <archivo_privado> -t stdio\` con el Python del entorno virtual. El inventario necesita un usuario autorizado y el servicio NETCONF/SSH del router debe estar accesible, habitualmente por el puerto 830.

**Guía completa, ejemplos, configuración VS Code y scripts PowerShell:** [Windows 11 / Quickstart](../windows11/README.md). Los scripts auxiliares tienen una comprobación estática inicial, pero están **pendientes de una validación integral en una instalación Windows limpia**.

## ¿Qué se comprobó realmente?

**Primera validación (ACX7024X):** invocación real de tools desde Copilot, con **16 sesiones BGP Established**, ninguna Down en la prueba, y **4 adyacencias IS-IS Level 2 Up**.

**Extensión del inventario:** el MCP reconoció **11 alias**. Eso no implica 11 equipos autenticados: el registro en memoria y la conexión NETCONF son etapas distintas.

**vRR Metro y Core:** \`gather_device_facts\` se completó para ambos Virtual Route Reflectors, identificando Junos **23.2R1.13** y plataforma vRR. Consultando \`show bgp summary\`, Copilot organizó **9 peers en cada vRR**: **8 Established y 1 Connect**. El éxito de la consulta MCP no significa que todas las sesiones BGP estén levantadas. Los contadores de flaps requieren contexto temporal; no se deduce automáticamente una causa raíz.

**Primera operación batch entre dos vRR:** \`show version\` finalizó **2/2 exitoso, 0 fallos, 3.045 segundos** de duración total reportada por la herramienta MCP. Ese número no es el tiempo total mostrado por la interfaz de Copilot, ni prueba que el batch sea más rápido que una secuencia comparable; falta un baseline serial medido.

## Una observación interesante: CLI frente a RPC XML

También se tomaron cuatro muestras individuales de duración, contrastando comandos CLI ejecutados por NETCONF contra RPC XML:

| Consulta | CLI (ms) | RPC (ms) |
| --- | ---: | ---: |
| Interfaces | 435 | 429 |
| Routing | 336 | 257 |
| BGP | 246 | 311 |
| IS-IS | 262 | 201 |

El XML facilitó obtener estructuras que se prestan al parsing. Estas cifras **no son un benchmark de rendimiento**, no se repitieron como serie estadística y no miden consumo de CPU ni volumen de paquetes sobre el enlace.

## Lo valioso de la experiencia

El valor no está solo en ejecutar comandos: es poder consultar un equipo real, obtener una respuesta verificable y utilizar la IA para **priorizar qué revisar**. Copilot pudo distinguir una llamada MCP exitosa de un estado BGP anómalo. La interpretación técnica continúa siendo responsabilidad del ingeniero.

El siguiente reto será comprobar las diferencias entre **MX, ACX y vRR**, continuar hasta RIB/FIB/PFE y analizar ConnectionPool y batch con metodologías comparables. Más adelante, en la tercera entrega, veremos LSP creados por políticas **BGP-SRTE**, y **stitching/interdomain con BGP-CT y BGP-LU**, correlacionando control plane y forwarding.

## Recursos y límites

- **Repositorio oficial de Juniper:** https://github.com/Juniper/junos-mcp-server
- **Código exacto usado en este laboratorio:** https://github.com/Juniper/junos-mcp-server/tree/75fe90afd7a0566f8c9e4c88099309aa12dee6e6
- **Documentación comunitaria Windows 11:** [Quickstart](../windows11/README.md)
- **Resultados agregados:** [Evidencias](../evidencias/RESULTADOS.md)
- **Seguridad y anonimización:** [Política de publicación](../SEGURIDAD.md)

Los resultados proceden de pruebas de laboratorio y no demuestran seguridad para producción. Antes de compartir información de red con una IA, es indispensable contar con autorización y aplicar políticas de acceso y divulgación.

**¿Han experimentado con MCP y herramientas de IA conectadas a equipos de networking reales?**

#Juniper #Junos #MCP #GitHubCopilot #NETCONF #PyEZ #NetworkAutomation #ServiceProvider #AIOps

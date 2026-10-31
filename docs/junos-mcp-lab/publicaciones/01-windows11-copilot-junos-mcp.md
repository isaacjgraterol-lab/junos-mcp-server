# Publicación #1: Del prompt al router — Copilot + Junos MCP en Windows 11

**Estado:** borrador listo para revisión y publicación. La explicación reproducible y el código oficial están enlazados abajo.

🚀 ¿Se puede consultar un router Juniper real desde lenguaje natural usando GitHub Copilot en Windows 11?

Lo probé con el **Junos MCP Server oficial de Juniper**, sin modificar `jmcp.py` y con consultas reales por NETCONF/PyEZ.

🔧 Entorno: Windows 11, Git, Python 3.11.7, VS Code 1.143.1, Copilot Agent y MCP sobre STDIO.

**Flujo:** Usuario → Copilot → MCP → PyEZ → NETCONF/SSH → Junos.

**Qué validamos:**

- 9 tools MCP y 11 dispositivos registrados (inventario no equivale a autenticación).
- ACX7024X: 16 BGP Established y 4 IS-IS Level 2 Up en la prueba original.
- Dos vRR Metro/Core: facts recuperados y 8/9 peers BGP Established en cada uno; un peer Connect requiere investigación.
- Primer batch entre dos vRR: `show version`, 2/2 PASS, 0 fallos y **3.045 s** reportados por el servidor MCP.

Lo interesante fue usar la IA para estructurar las salidas, señalar sesiones no establecidas y distinguir resultados observados de hipótesis. La IA no sustituyó las verificaciones del ingeniero. Los tiempos son muestras puntuales; no se han demostrado ganancias de rendimiento ni capacidad de producción.

**Pasos y comandos completos:** [Guía Windows 11](../windows11/README.md).  
**Evidencias:** [Resultados resumidos](../evidencias/RESULTADOS.md).  
**Origen:** https://github.com/Juniper/junos-mcp-server

Siguiente episodio: MX, ACX y vRR; RIB, FIB, PFE, next-hops, ConnectionPool y batch.

#Juniper #Junos #MCP #GitHubCopilot #NETCONF #NetworkAutomation #ServiceProvider #AIOps

---

## Nota para artículo largo en LinkedIn

Usar esta guía como base. En el editor de artículos insertar una portada y secciones: **Objetivo → entorno Windows 11 → instalación y configuración → arquitectura → pruebas ACX/vRR → batch → seguridad → límites → próximos pasos**. Mantener los comandos extensos en GitHub como fuente canónica; en LinkedIn enlazar a la versión exacta de la guía. Añadir solo capturas anonimizadas con autorización.

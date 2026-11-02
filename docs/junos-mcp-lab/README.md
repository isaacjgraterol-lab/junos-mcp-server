# Junos MCP × GitHub Copilot — Field Lab Notebook

Documentación pública del laboratorio **Windows 11 + VS Code + GitHub Copilot + Juniper Junos MCP Server (oficial)**.

> **Repositorio del servidor original:** https://github.com/Juniper/junos-mcp-server  
> **Versión reproducida en este laboratorio:** [commit 75fe90afd7a0566f8c9e4c88099309aa12dee6e6](https://github.com/Juniper/junos-mcp-server/tree/75fe90afd7a0566f8c9e4c88099309aa12dee6e6).  
> Esta carpeta es material **comunitario / no oficial**, no una modificación de jmcp.py ni una distribución respaldada por Juniper.

## Empieza aquí

1. [Instalación reproducible en Windows 11](windows11/README.md) — pasos, scripts auxiliares y troubleshooting.
2. [Resultados de laboratorio](evidencias/RESULTADOS.md) — qué validamos y qué sigue pendiente.
3. [Publicación #1: artículo completo listo para LinkedIn](publicaciones/01-articulo-linkedin-completo.md) y [versión breve](publicaciones/01-windows11-copilot-junos-mcp.md).
4. [Roadmap de 3 publicaciones](ROADMAP.md).
5. [Seguridad y publicación responsable](SEGURIDAD.md).

## Arquitectura

**Usuario → GitHub Copilot (modo Agent, VS Code) → MCP (STDIO) → Juniper PyEZ → NETCONF/SSH → Junos.**

El inventario privado se carga desde un archivo local **fuera del repositorio**; registrar un dispositivo no implica abrir NETCONF ni garantizar autenticación.

## Resultados documentados — 31 oct 2026

| Escenario | Resultado confirmado |
| --- | --- |
| MCP / VS Code | 9 tools descubiertas en el commit probado |
| Inventario | 11 alias reconocidos, sin afirmar 11 sesiones autenticadas |
| ACX7024X | 16 BGP Established y 4 IS-IS L2 Up en la prueba original |
| vRR Metro | Facts PASS; 8/9 BGP Established, 1 Connect |
| vRR Core | Facts PASS; 8/9 BGP Established, 1 Connect |
| Batch de dos vRR | show version: 2/2 PASS, 0 FAIL, 3.045 s MCP |
| CPU / serial baseline / PFE | No medidos o no probados aún |

La duración total de Copilot no equivale a duración de la herramienta MCP; los tiempos indicados son puntuales, **no benchmarks**.

## Reglas

- No subir devices.json, credentials.json, claves, contraseñas, direcciones privadas ni capturas sin revisar.
- Solo equipos autorizados y respetando las reglas de envío de datos a proveedores de IA.
- El servidor oficial también permite configurar dispositivos: el modo Agent **no es RBAC**. Usar cuentas Junos con privilegios mínimos, sin autoaprobar herramientas de escritura.
- Los scripts auxiliares están preparados para reproducibilidad; **no se ha certificado todavía una instalación completa desde cero en otro equipo Windows 11**.

## Autoría y referencias

Laboratorio comunitario de ingeniería de redes; fuente de código MCP: Juniper. Documentación de laboratorio, capturas y conclusiones se desarrollan independientemente del proyecto original.

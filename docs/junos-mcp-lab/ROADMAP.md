# Serie técnica: AI + Junos MCP + Service Provider Networking

Tres publicaciones, propuesta de frecuencia semanal **dependiente de validaciones reales**, no fechas garantizadas.

## #1 — Windows 11 + GitHub Copilot + Junos MCP

**Alcance:** instalación paso a paso, arquitectura, inventario, herramientas MCP, ACX, dos vRR, interpretación BGP y primer batch multi-router.

**Estado:** texto y resultados disponibles; faltan última revisión de datos sensibles, autorización para publicar y validación externa de los scripts Plug & Play.

## #2 — MCP multiplataforma: MX, ACX, PTX y cRPD

**Alcance:** validar las cuatro plataformas con el mismo MCP oficial, sin modificar `jmcp.py`. Los vRR ya probados sirven como línea base adicional.

| Plataforma | Foco de análisis | Límite de interpretación |
| --- | --- | --- |
| MX | BGP/MPLS, RIB/FIB, PFE, NHDB, composite/indirect next-hops | Depende de hardware y release |
| ACX | Junos Evolved, IS-IS/SR-MPLS, RIB/FIB, interfaces y PFE | Comandos PFE/ASIC dependen del modelo |
| PTX | Backbone MPLS, rutas instaladas, PFE y contadores de forwarding | Validar variantes de sintaxis por plataforma |
| cRPD | BGP, IGP, políticas, Route Reflection, RIB y resolución | cRPD independiente es control plane; no asumir PFE físico |

**Pruebas comunes:** facts, versiones, conectividad/autenticación NETCONF, lectura BGP/IGP, compatibilidad de RPC, fallas de herramienta, tiempos (serial y batch), ConnectionPool y seguridad efectiva. **Pruebas específicas de forwarding** solo donde exista PFE o se integre un forwarding plane verificable. En cRPD, comprobar control plane y distinguir si se ejecuta como componente de Juniper Cloud-Native Router.

**Evidencia pendiente:** pruebas de MX/ACX/PTX/cRPD, compatibilidad por modelo/release, mediciones repetidas y baseline serial, NHDB/next-hop hierarchy, errores de PFE y permisos. No afirmar aceleraciones ni paridad de capacidades sin evidencia.

## #3 — Troubleshooting avanzado Service Provider

**BGP-SRTE:** correlación entre SR Policies anunciadas por BGP, color, endpoint, candidate paths, segment lists y los **LSP instalados creados por políticas BGP**, con resolución del servicio y comprobaciones de forwarding.

**BGP-CT y BGP-LU:** transport classes y rutas etiquetadas, **stitching entre dominios**, ABR/ASBR, next-hop resolution, continuidad del transporte y etiquetas a través de Metro / Core / SuperCore.

**Complementos:** SR-MPLS, EVPN, VPN, selección de transporte, RIB/FIB/PFE y fallos interdomain. Separar control plane observado de programación efectiva del plano de datos.

### Criterio editorial

Publicar solo resultados sustentados por salida real anonimizada. Distinguir PASS de la tool, estado del protocolo y diagnóstico de causa raíz. Todas las herramientas de escritura quedan fuera de las pruebas.

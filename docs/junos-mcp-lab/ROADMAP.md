# Serie técnica: AI + Junos MCP + Service Provider Networking

Tres publicaciones, propuesta de frecuencia semanal **dependiente de validaciones reales**, no fechas garantizadas.

## #1 — Windows 11 + GitHub Copilot + Junos MCP

**Alcance:** instalación paso a paso, arquitectura, inventario, herramientas MCP, ACX, dos vRR, interpretación BGP y primer batch multi-router.

**Estado:** texto y resultados disponibles; faltan última revisión de datos sensibles, autorización para publicar y validación externa de los scripts Plug & Play.

## #2 — MCP multiplataforma: MX, ACX y vRR

**Alcance:** facts y compatibilidad, RIB/FIB, PFE, next-hop hierarchy, NX/NHDB según plataforma, ConnectionPool, batch, serial baseline y rendimiento.

**Evidencia pendiente:** mediciones repetidas, tests reales en MX/ACX, sintaxis PFE específica por equipo y permisos de la cuenta. No atribuir mejoras de rendimiento sin datos comparables.

## #3 — Troubleshooting avanzado Service Provider

**BGP-SRTE:** correlación entre SR Policies anunciadas por BGP, color, endpoint, candidate paths, segment lists y los **LSP instalados creados por políticas BGP**, con resolución del servicio y comprobaciones de forwarding.

**BGP-CT y BGP-LU:** transport classes y rutas etiquetadas, **stitching entre dominios**, ABR/ASBR, next-hop resolution, continuidad del transporte y etiquetas a través de Metro / Core / SuperCore.

**Complementos:** SR-MPLS, EVPN, VPN, selección de transporte, RIB/FIB/PFE y fallos interdomain. Separar control plane observado de programación efectiva del plano de datos.

### Criterio editorial

Publicar solo resultados sustentados por salida real anonimizada. Distinguir PASS de la tool, estado del protocolo y diagnóstico de causa raíz. Todas las herramientas de escritura quedan fuera de las pruebas.

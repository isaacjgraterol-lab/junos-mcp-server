# Seguridad y anonimización — publicación pública

**Este proyecto da a un agente de IA acceso a dispositivos de red. Es un laboratorio, no una recomendación de despliegue en producción.**

## No publicar

- Dispositivos y credenciales reales (devices.json, credentials.json, tokens, claves privadas, contraseñas).
- IP de gestión, ASN de producción, hostname, seriales, rutas corporativas, identidades de vecinos o clientes.
- Capturas de VS Code que incluyan archivos privados en contexto del chat, variables de entorno o terminales con secretos.
- Información operativa sometida a restricciones contractuales o de política empresarial.

## Sí publicar tras revisión

- Nombres de laboratorio inventados como LAB-RTR-01.
- IP de documentación: 192.0.2.0/24, 198.51.100.0/24, 203.0.113.0/24.
- Métricas agregadas verificadas y metodología transparente.
- Herramientas y comandos read-only autorizados.
- Estructuras de ejemplo sin credenciales auténticas.

## Controles

1. Cuenta NETCONF/Junos con permisos efectivamente limitados a lectura (auditar permisos; no asumirlos).
2. MCP local vía STDIO en el caso documentado; no publicar un endpoint remoto sin autenticación y controles.
3. Copilot Agent: sin autoaprobación de operaciones desconocidas ni herramientas de escritura.
4. Evitar que información interna o secreta entre al contexto del modelo.
5. No confundir blocklist de comandos con una allowlist de lectura o con RBAC.
6. Rotar toda credencial que haya sido expuesta por cualquier canal.
7. Revisar cualquier archivo/captura manualmente antes de publicarlo.

**Importante:** Los ejemplos de autenticación por contraseña guardan el secreto en claro en devices.json para compatibilidad con el formato probado. Se recomienda clave SSH y control de acceso al archivo local. No subir archivos de inventario privados, ni siquiera en un repositorio privado que pueda hacerse público posteriormente.

Referencias: https://github.com/Juniper/junos-mcp-server y https://code.visualstudio.com/docs/agents/reference/mcp-configuration

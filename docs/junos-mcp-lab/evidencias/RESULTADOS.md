# Evidencia resumida (31 de octubre de 2026)

Datos agregados y anonimizados extraídos de las pruebas del laboratorio. Estas cifras no representan un benchmark ni una auditoría de producción.

| Prueba | Tool / comando | Resultado |
|---|---|---|
| Inventario | `get_router_list` | 11 alias reconocidos |
| vRR Metro | `gather_device_facts` | NETCONF/PyEZ PASS; vRR, RE-VRR, Junos 23.2R1.13 |
| vRR Core | `gather_device_facts` | NETCONF/PyEZ PASS; vRR, RE-VRR, Junos 23.2R1.13 |
| vRR Metro | `show bgp summary` | 9 peers, 8 Established, 1 Connect, 4 grupos; flap counts 35–96 |
| vRR Core | `show bgp summary` | 9 peers, 8 Established, 1 Connect, 3 grupos; flap counts 34–403 |
| vRR Metro + Core | `execute_junos_command_batch` / `show version` | 2/2 éxito, 0 fallos, **3.045 s batch total**; duraciones individuales reportadas 3.044 s y 0.481 s |
| ACX7024X original | consultas BGP / IS-IS | 16 Established / 0 Down y 4 IS-IS L2 Up |
| CLI vía NETCONF vs RPC XML | cuatro operaciones | tiempos puntuales, sin CPU ni línea base repetida |

**Tiempos CLI vs RPC (ms):** interfaces 435/429, routing 336/257, BGP 246/311, IS-IS 262/201.

**Interpretación:** el éxito de una tool MCP **no significa** que todas las sesiones BGP estén sanas. Un vecino Connect no determina por sí solo la causa raíz. Los contadores de flaps son acumulados observados, sin prueba de cuándo ocurrieron. La diferencia entre ejecución individual y batch **no prueba aceleración** sin baseline serial comparable.

**Pendientes:** AXC/MX adicionales, RIB/FIB/PFE, ConnectionPool repetido, mediciones estandarizadas, lectura efectiva de privilegios Junos, autorizar publicaciones. No publicar logs/capturas originales con datos privados.

# DECISIONES DEL PROYECTO  
Sistema: Salón de belleza — Perú  
Documento: decisiones.md  
Fecha: 2026 (Revisión v2)

---

## 1. Alcance del negocio

- El sistema opera en un solo local (sin multi-sede).
- Se gestionan turnos entre cliente y estilista.
- Se realizan ventas directas sin turno.
- Se vende y se consume internamente productos.
- Se controla inventario con stock mínimo.
- Se registra historial de servicios por cliente.
- El pago puede ser mixto (varios métodos en una venta).
- El estilista no tiene acceso al sistema.
- Se requiere historial tributario y operativo completo.

---

## 2. Gestión de usuarios y roles

Roles definidos:

- Administrador
- Encargado
- Cajero

Decisiones:

- Los estilistas no son usuarios del sistema.
- Roles se gestionan desde base (no hardcode).
- Las capacidades por rol se implementarán en aplicación, no DB.

---

## 3. Clientes

- Los clientes se registran formalmente.
- Los clientes pueden comprar sin turno.
- Se guarda historial para fidelización y facturación.

---

## 4. Servicios

- Los servicios tienen categoría simple (no jerárquica).
- Precio único por servicio (no depende del estilista).
- Se almacena duración estimada (en minutos).
- Cada servicio tiene afectación IGV y unidad SUNAT.
- **Cambios en catálogo:** Si un servicio cambia de nombre o precio, no afecta ventas pasadas (ver punto 8.1).

---

## 5. Turnos

- Un turno asocia cliente + estilista + servicios.
- Un turno puede tener múltiples servicios.
- El turno no implica una cita futura (no agenda).
- El turno existe solo cuando hay algo que cobrar.

---

## 6. Inventario

- Existe catálogo de productos.
- Inventario perpetuo con movimientos.
- Tipos de movimiento definidos:
  - entrada
  - salida_venta
  - salida_consumo
  - ajuste
- No se registra consumo exacto por servicio (sin recetas).
- Productos tienen stock mínimo.
- Unidad y afectación tributaria SUNAT aplican también a productos.

---

## 7. Ventas y caja

- Venta puede venir de un turno o ser directa.
- Caja se abre y se cierra por usuario.
- Se permite pago mixto.
- Se permite anulación de venta.
- No se registra propina en primera versión.
- Venta puede contener:
  - servicios
  - productos
  - ambos
- **Totales calculados:** La venta almacena los desgloses tributarios (Gravado, Exonerado, IGV) para reportes rápidos sin depender de los comprobantes.

---

## 8. Comprobantes electrónicos (CPE)

- Se soportan tipos:
  - Factura (01)
  - Boleta (03)
  - Ticket interno (00, no SUNAT)
- Se requiere emitir XML UBL 2.1.
- Se almacena hash, QR y CDR.
- Cada CPE tiene estado:
  - emitido
  - pendiente_envio
  - enviado
  - aceptado
  - rechazado
  - anulado
- Existe modo contingencia y reenvío.
- Existe comunicación de baja.

## 8.1 Inmutabilidad de Comprobantes y Ventas (Snapshot)

- **Datos del Receptor:** El comprobante debe almacenar una copia de los datos del cliente (Razón Social, RUC, Dirección) tal como estaban al momento de la emisión.
- **Datos Tributarios del Ítem:** Cada línea del detalle de venta almacenará el `% IGV`, `código de afectación`, `precio unitario` y `nombre` vigentes al momento de la venta.
- **Independencia del Catálogo:** La edición o eliminación (soft delete) de productos/servicios en el catálogo maestro no altera los registros históricos de venta.

---

## 9. Series y correlativos

- Se soportan múltiples series por tipo.
- Correlativo es incremental y con padding.
- No se permite “dejar sin enviar” comprobantes tributarios.
- Ticket interno no se envía a OSE/SUNAT.

---

## 10. SUNAT - Catálogos oficiales

Se usan:
- Catálogo afectación IGV (51)
- Catálogo unidad de medida (03)
- Catálogo tipo comprobante (01)

---

## 11. Integración PSE/OSE

- Se soporta múltiples proveedores PSE.
- Se soporta sandbox y producción.
- Se almacenan credenciales y endpoints por proveedor.
- Se guarda log técnico completo.
- No se acopla el negocio a un proveedor específico.

---

## 12. Configuración del negocio

- IGV es configurable.
- Precio incluye IGV (true).
- Emisión automática de CPE es configurable.

---

## 13. Base de datos

- MySQL 8.0.30 (InnoDB, utf8mb4_unicode_ci).
- Tablas en plural, snake_case.
- PK auto_increment, FK con cascada lógica.
- **Soft Deletes:** Se utilizará borrado lógico (`deleted_at`) para entidades maestras (Productos, Servicios, Clientes) para mantener integridad histórica.
- Sin triggers contables.

---

## 14. Laravel

- Versión objetivo: Laravel 11.
- Seeds incluidos.
- Migraciones pendientes.

---

## 15. Exclusiones (v1)

- Notas de crédito, Multi-sede, Subcategorías, Costeo exacto, Propinas, Fidelización, Gift cards, Citas/agenda, App móvil, Multi-tenant.

---

## 16. Extensibilidad futura

- Arquitectura lista para agregar proveedores, agenda, pasarelas de pago y módulos adicionales sin refactorización mayor.
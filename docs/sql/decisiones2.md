# DECISIONES DEL PROYECTO
Sistema: Salón de belleza — Perú
Documento: decisiones.md
Fecha: 2026 (Versión Final SFS)

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
- **Roles:** Administrador, Encargado, Cajero.
- Los estilistas NO son usuarios del sistema.
- Roles gestionados en base de datos.

---

## 3. Clientes
- Registro formal obligatorio para Facturas.
- Opcional para Boletas menores (Clientes varios).
- Se utiliza "Soft Deletes" para mantener historial si se elimina un cliente.

---

## 4. Servicios
- Categoría simple.
- Precio único (independiente del estilista).
- **Inmutabilidad:** Si se cambia el precio o nombre de un servicio, las ventas pasadas NO se ven afectadas (se usa Snapshot).

---

## 5. Turnos
- Asocia Cliente + Estilista + Servicios.
- No implica agenda futura (se crea al momento de la atención).

---

## 6. Inventario
- Inventario perpetuo.
- Movimientos: entrada, salida_venta, salida_consumo, ajuste.
- Sin recetas (no se descuenta champú por ml al hacer un servicio).

---

## 7. Ventas y caja
- Apertura y Cierre de caja por usuario.
- **Snapshot Tributario:** La venta almacena los desgloses (Gravado, Exonerado, IGV) calculados al momento de la venta para reportes rápidos sin depender de los XML.

---

## 8. Comprobantes y Facturación (Modelo Híbrido)
Se manejan dos flujos diferenciados por el campo `genera_xml`:

### A. Documentos Tributarios (Factura 01, Boleta 03)
- Se requiere emitir XML UBL 2.1.
- **Tecnología:** Facturador SUNAT (SFS) gratuito.
- **Mecanismo:** Intercambio de archivos planos (JSON/TXT) en carpetas locales.
- **Ciclo:** Sistema genera archivo -> SFS lo procesa -> SFS devuelve CDR -> Sistema lee CDR.

### B. Documentos Internos (Ticket 00)
- Solo para control interno.
- No genera XML.
- No interactúa con el Facturador SUNAT.
- Descuenta stock y registra ingreso en caja igual que una factura.

## 8.1 Inmutabilidad (Snapshots)
- **Receptor:** El comprobante guarda copia del RUC/Nombre/Dirección del cliente al momento de la emisión.
- **Ítems:** El detalle de venta guarda copia del Nombre, Precio y %IGV del producto/servicio al momento de la venta.

---

## 9. Series y correlativos
- Series separadas para Facturas (F001), Boletas (B001) y Tickets (T001).
- Control de correlativos independiente.

---

## 10. SUNAT - Catálogos oficiales
- Se respetan los códigos de catálogos SUNAT (Afectación IGV, Unidades, Tipos Doc) para compatibilidad con el SFS.

---

## 11. Integración Técnica (SFS Local)
- No se usan APIs externas (PSE).
- El sistema debe tener permisos de escritura/lectura en las carpetas del SFS (`DATA`, `RPTA`).
- Se requiere que el aplicativo SFS (Java) esté en ejecución para firmar los comprobantes.
- Existe una tabla de configuración para definir las rutas de las carpetas, permitiendo mover el sistema sin recompilar.

---

## 12. Configuración del negocio
- Precios incluyen IGV (configurable).
- Emisión automática activada por defecto.

---

## 13. Base de datos
- MySQL 8.0.30.
- **Soft Deletes:** Aplicado a Clientes, Productos, Servicios, Estilistas.
- **Integridad:** FK con restricciones para evitar borrados accidentales de data histórica.

---

## 14. Stack Tecnológico
- Backend: Laravel 11.
- Servidor Local: Laragon (Windows).
- Facturador: SUNAT SFS (Versión vigente).

---

## 15. Exclusiones (Versión 1)
- Notas de crédito (se anulan boletas completas).
- Cotizaciones.
- Citas/Reservas futuras.
- App móvil.
# Especificación Técnica: Plantillas Excel de Captura Estandarizada (Fase 2)

## Objetivo
Establecer el estándar de diseño y las reglas de validación (*Data Entry Safeguards*) para las planillas operativas en Excel (`plantilla_ventas_devengadas.xlsx`, `plantilla_compras.xlsx` y `plantilla_movimientos_caja.xlsx`). El propósito es garantizar la integridad de los datos en la fuente antes de ser procesados por las tablas de mapeo y cargados al Core RDBMS.

---

## 1. Plantilla de Ventas / Devengados (`plantilla_ventas_devengadas.xlsx`)

* **Propósito:** Capturar facturas y devengos de clientes/sponsors.
* **Estructura y Reglas de Campo:**
  1. `Folio Factura`: Texto sin espacios extras (ej: `FAC-2026-001`). Obligatorio.
  2. `Fecha Emisión`: Formato fecha estricto `AAAA-MM-DD`. Obligatorio.
  3. `Cliente (Excel)`: Lista desplegable conectada a `map_clientes.nombre_informal_excel`.
  4. `Ítem / Servicio (Excel)`: Lista desplegable conectada a `map_productos.descripcion_libre_excel`.
  5. `Cantidad`: Numérico decimal estricto (`> 0`).
  6. `Precio Unitario`: Numérico decimal estricto (`>= 0`).
  7. `Estado Venta`: Lista desplegable restringida a: `DEVENGADO`, `FACTURADO`, `PAGADO`, `ANULADO`.

---

## 2. Plantilla de Compras (`plantilla_compras.xlsx`)

* **Propósito:** Registrar órdenes de compra y gastos operativos con proveedores.
* **Estructura y Reglas de Campo:**
  1. `Folio OC`: Texto sin espacios extras (ej: `OC-2026-001`). Obligatorio.
  2. `Fecha Emisión`: Formato fecha estricto `AAAA-MM-DD`. Obligatorio.
  3. `Proveedor (Excel)`: Lista desplegable conectada a `map_clientes.nombre_informal_excel`.
  4. `Insumo / Ítem (Excel)`: Lista desplegable conectada a `map_productos.descripcion_libre_excel`.
  5. `Cantidad`: Numérico decimal estricto (`> 0`).
  6. `Precio Unitario`: Numérico decimal estricto (`>= 0`).
  7. `Estado OC`: Lista desplegable restringida a: `BORRADOR`, `APROBADA`, `RECIBIDA`, `ANULADA`.

---

## 3. Plantilla de Tesorería / Caja (`plantilla_movimientos_caja.xlsx`)

* **Propósito:** Garantizar el registro limpio del flujo de efectivo con montos absolutos positivos.
* **Estructura y Reglas de Campo:**
  1. `Fecha Movimiento`: Formato fecha estricto `AAAA-MM-DD`. Obligatorio.
  2. `Código Cuenta Bancaria`: Lista desplegable vinculada a cuentas corrientes/caja de `cat_plan_cuentas` (Fase 1).
  3. `Tipo de Flujo`: Lista desplegable restringida a: `INGRESO`, `EGRESO`, `TRASPASO_HASTA`, `TRASPASO_DESDE`.
  4. `Monto Absoluto`: Numérico decimal estricto positivo (`> 0`). *Prohibido ingresar valores negativos*.
  5. `Glosa Movimiento`: Texto descriptivo obligatorio.
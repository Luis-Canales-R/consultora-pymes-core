# Documentación Técnica: Lógica ETL y Procesamiento de Transición (Fase 2)

## Objetivo
Definir el mecanismo mediante el cual los datos crudos o semitransaccionales provenientes de las plantillas de Excel de las PyMEs se validan, cruzan a través de las tablas de homologación (`map_clientes`, `map_productos`) y se insertan de forma íntegra en el Core RDBMS transaccional (Fase 1).

---

## 1. Flujo Lógico del Procesamiento (ETL)

1. **Extracción / Carga de Staging:** Los registros de las planillas de Ventas, Compras y Tesorería se cargan temporalmente en tablas de staging o directamente a través de Stored Procedures transaccionales que reciben los parámetros limpios.
2. **Homologación Automática (Lookup):**
   * El nombre informal del cliente (`nombre_informal_excel`) se busca en `map_clientes` para obtener el `id_tercero_oficial`. Si no existe, el motor rechaza el lote para evitar datos huérfanos.
   * La descripción del producto (`descripcion_libre_excel`) se cruza con `map_productos` para recuperar el `id_item_oficial` canónico.
3. **Inyección al Core RDBMS:** 
   * Las ventas devengadas se mapean hacia `tbl_ventas_devengadas` y `tbl_ventas_detalle`.
   * Las compras se asignan a `tbl_ordenes_compra` y `tbl_compras_detalle`.
   * Los movimientos de caja alimentan `tbl_movimientos_caja` validando la consistencia de los montos absolutos.

---

## 2. Definición del Stored Procedure Maestro de Ingesta

El procedimiento almacenado principal (`sp_procesar_transaccion_externa`) se encargará de validar las llaves de mapeo antes de comitear los cambios en el Core, asegurando transaccionalidad total (`BEGIN TRANSACTION` / `COMMIT` / `ROLLBACK`).
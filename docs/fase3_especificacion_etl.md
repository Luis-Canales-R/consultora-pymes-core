# Especificación Técnica: Procedimiento ETL - Fase 3 (`sp_procesar_etl_fase3`)

## 1. Objetivo
El Stored Procedure `sp_procesar_etl_fase3` centraliza la lógica de control transaccional para la ingesta de las planillas operativas, asegurando que se ejecuten las validaciones cruzadas antes de impactar los saldos y movimientos del Core RDBMS.

## 2. Parámetros de Entrada
* `@nombre_archivo` (VARCHAR(150)): Identificador del archivo Excel origen procesado en la sesión de carga.

## 3. Manejo de Errores
Cualquier inconsistencia detectada (como claves de clientes no encontradas en `map_clientes` o montos inválidos) genera automáticamente una inserción en la tabla de auditoría `tbl_log_errores_etl` con el detalle de la fila y la pestaña de origen.
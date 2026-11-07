# Especificación Técnica: Procedimiento ETL - Fase 3 (`sp_procesar_etl_fase3`)

## 1. Objetivo
El Stored Procedure `sp_procesar_etl_fase3` centraliza la lógica de control transaccional para la ingesta de las planillas operativas, asegurando que se ejecuten las validaciones cruzadas antes de impactar los saldos y movimientos del Core RDBMS.

## 2. Parámetros de Entrada
* `@nombre_archivo` (VARCHAR(150)): Identificador del archivo Excel origen procesado en la sesión de carga.
* `@pestana_origen` (VARCHAR(50)): Nombre de la pestaña o hoja del archivo evaluada (por defecto 'Datos').

## 3. Manejo de Errores y Auditoría
Cualquier inconsistencia detectada (como claves de clientes no encontradas en `map_clientes` o desvíos en formatos) genera automáticamente una inserción en la tabla de auditoría `tbl_log_errores_etl` detallando la fila y la pestaña de origen.
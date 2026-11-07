# Especificación Técnica: Tabla de Staging - Fase 3 (`tbl_staging_carga`)

## 1. Objetivo
La tabla `tbl_staging_carga` actúa como el área de transferencia temporal (*staging area*) para almacenar los registros sin procesar extraídos de las plantillas de Excel antes de aplicar las validaciones cruzadas del motor ETL.

## 2. Estructura de Campos
* `id_staging` (INT, PK): Identificador autoincremental de la fila de staging.
* `numero_fila` (INT): Número de línea correspondiente en la hoja de Excel origen.
* `codigo_cliente` (VARCHAR(50)): Clave recibida del cliente para validación contra `map_clientes`.
* `codigo_producto` (VARCHAR(50)): Referencia del producto o servicio.
* `cantidad` / `monto_total` (DECIMAL): Métricas operativas y financieras.
* `estado_carga` (VARCHAR(30)): Estado del registro (por defecto 'PENDIENTE').
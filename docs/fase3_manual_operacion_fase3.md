# Manual de Operación e Instructivo Técnico - Fase 3
## Motor ETL, Homologación y Auditoría de Calidad de Datos

---

## 1. Propósito y Alcance
Este manual describe la arquitectura, componentes y procedimiento operativo de la **Fase 3** del sistema RDBMS para PyMEs. Su objetivo principal es asegurar la ingesta limpia, validación cruzada y trazabilidad de errores de los datos operacionales provenientes de archivos externos antes de su consolidación en el núcleo analítico.

---

## 2. Arquitectura de Objetos en Base de Datos (`consultora_pymes_core`)

El motor opera sobre los siguientes objetos principales:
* **`tbl_staging_carga`**: Área de transferencia temporal (*staging*). Recibe los registros crudos de las planillas de origen.
* **`map_clientes`**: Tabla de homologación maestra. Relaciona los nombres informales del Excel (`nombre_informal_excel`) con los identificadores oficiales (`id_tercero_oficial`), provista de una llave primaria autoincremental (`IDENTITY`).
* **`tbl_log_errores_etl`**: Bitácora de auditoría. Almacena las anomalías detectadas durante el procesamiento, aislando los registros que no cumplen con las reglas de negocio.
* **`sp_procesar_etl_fase3`**: Procedimiento almacenado transaccional que ejecuta las validaciones cruzadas y registra las incidencias automáticamente.

---

## 3. Guía de Operación Paso a Paso

Para ejecutar una corrida de validación e ingesta, siga este procedimiento estándar en SQL Server Management Studio (SSMS):

### Paso 1: Carga de datos al área de Staging
Inserte o importe los registros crudos del archivo de origen en la tabla temporal:
```sql
TRUNCATE TABLE dbo.tbl_staging_carga;

INSERT INTO dbo.tbl_staging_carga (numero_fila, codigo_cliente, codigo_producto, cantidad, monto_total, fecha_transaccion)
VALUES 
(1, 'Cliente_A', 'Prod_01', 10, 1500.00, '2026-11-07');
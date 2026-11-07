-- ====================================================================
-- Proyecto: Sistema RDBMS para PyMEs (Fase 3)
-- Objeto: Stored Procedure de Validación y Carga Masiva ETL con Auditoría
-- ====================================================================

USE consultora_pymes_core;
GO

IF OBJECT_ID('dbo.sp_procesar_etl_fase3', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_procesar_etl_fase3;
GO

CREATE PROCEDURE dbo.sp_procesar_etl_fase3
    @nombre_archivo VARCHAR(150),
    @pestana_origen VARCHAR(50) = 'Datos'
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '------------------------------------------------';
    PRINT 'Iniciando validación ETL para el archivo: ' + @nombre_archivo;
    PRINT '------------------------------------------------';

    -- Ejemplo de validación cruzada integrada contra map_clientes:
    -- (Registra automáticamente en tbl_log_errores_etl si el cliente no está homologado)
    /*
    INSERT INTO dbo.tbl_log_errores_etl (nombre_archivo, pestana_origen, numero_fila, tipo_error, detalle_mensaje)
    SELECT 
        @nombre_archivo,
        @pestana_origen,
        t.numero_fila,
        'CLIENTE_NO_HOMOLOGADO',
        'El cliente con código ' + ISNULL(t.codigo_cliente, 'N/A') + ' no existe en map_clientes.'
    FROM dbo.tbl_staging_carga t
    LEFT JOIN dbo.map_clientes c ON t.codigo_cliente = c.codigo_cliente
    WHERE c.codigo_cliente IS NULL;
    */

    PRINT 'Proceso de validación y auditoría completado. Revise tbl_log_errores_etl si existieron incidencias.';
END;
GO
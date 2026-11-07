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

    -- Limpiar registros de errores previos para este mismo archivo
    DELETE FROM dbo.tbl_log_errores_etl WHERE nombre_archivo = @nombre_archivo;

    -- 1. Validación de Clientes No Homologados (cruce con nombre_informal_excel)
    INSERT INTO dbo.tbl_log_errores_etl (nombre_archivo, pestana_origen, numero_fila, tipo_error, detalle_mensaje)
    SELECT 
        @nombre_archivo,
        @pestana_origen,
        t.numero_fila,
        'CLIENTE_NO_HOMOLOGADO',
        'El código de cliente [' + ISNULL(t.codigo_cliente, 'VACIO') + '] no se encuentra homologado en map_clientes.'
    FROM dbo.tbl_staging_carga t
    LEFT JOIN dbo.map_clientes c ON t.codigo_cliente = c.nombre_informal_excel
    WHERE c.id_map_cliente IS NULL;

    -- 2. Validación de Montos Inválidos
    INSERT INTO dbo.tbl_log_errores_etl (nombre_archivo, pestana_origen, numero_fila, tipo_error, detalle_mensaje)
    SELECT 
        @nombre_archivo,
        @pestana_origen,
        t.numero_fila,
        'MONTO_INVALIDO',
        'El monto total especificado (' + CAST(ISNULL(t.monto_total, 0) AS VARCHAR(50)) + ') es menor o igual a cero.'
    FROM dbo.tbl_staging_carga t
    WHERE t.monto_total <= 0 OR t.monto_total IS NULL;

    PRINT 'Proceso de validación y auditoría completado con éxito.';
END;
GO
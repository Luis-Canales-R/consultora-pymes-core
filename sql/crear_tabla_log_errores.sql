-- ====================================================================
-- Proyecto: Sistema RDBMS para PyMEs (Fase 3)
-- Objeto: Creación de la Tabla de Auditoría de Errores y Procedimiento de Validación ETL
-- ====================================================================

USE GestionPymesCore;
GO

-- 1. Creación de la tabla de auditoría de errores
IF OBJECT_ID('dbo.tbl_log_errores_etl', 'U') IS NOT NULL
    DROP TABLE dbo.tbl_log_errores_etl;
GO

CREATE TABLE dbo.tbl_log_errores_etl (
    id_log INT IDENTITY(1,1) PRIMARY KEY,
    nombre_archivo VARCHAR(150) NOT NULL,
    pestana_origen VARCHAR(50) NOT NULL,
    numero_fila INT NOT NULL,
    tipo_error VARCHAR(50) NOT NULL,
    detalle_mensaje VARCHAR(500) NOT NULL,
    fecha_intento DATETIME DEFAULT GETDATE()
);
GO

CREATE INDEX IX_log_errores_archivo_pestana 
ON dbo.tbl_log_errores_etl (nombre_archivo, pestana_origen, fecha_intento);
GO

PRINT 'Tabla tbl_log_errores_etl creada exitosamente.';
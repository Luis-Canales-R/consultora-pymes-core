-- ====================================================================
-- Proyecto: Sistema RDBMS para PyMEs (Fase 3)
-- Objeto: Creación de la Tabla de Staging para Carga Masiva
-- ====================================================================

USE consultora_pymes_core;
GO

-- 1. Eliminación previa si existe
IF OBJECT_ID('dbo.tbl_staging_carga', 'U') is not null
    DROP TABLE dbo.tbl_staging_carga;
GO

-- 2. Creación de la tabla de staging que recibe los datos crudos del Excel
CREATE TABLE dbo.tbl_staging_carga (
    id_staging INT IDENTITY(1,1) PRIMARY KEY,
    numero_fila INT NOT NULL,
    codigo_cliente VARCHAR(50) NULL,
    codigo_producto VARCHAR(50) NULL,
    cantidad DECIMAL(18,2) NULL,
    monto_total DECIMAL(18,2) NULL,
    fecha_transaccion DATE NULL,
    estado_carga VARCHAR(30) DEFAULT 'PENDIENTE',
    fecha_proceso DATETIME DEFAULT GETDATE()
);
GO

PRINT 'Tabla tbl_staging_carga creada exitosamente en consultora_pymes_core.';
GO
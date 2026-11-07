-- ====================================================================
-- Proyecto: Sistema RDBMS para PyMEs (Fase 3)
-- Objeto: Creación de la Tabla de Homologación de Clientes (`map_clientes`)
-- ====================================================================

USE consultora_pymes_core;
GO

-- 1. Eliminación previa si existe
IF OBJECT_ID('dbo.map_clientes', 'U') IS NOT NULL
    DROP TABLE dbo.map_clientes;
GO

-- 2. Creación de la tabla con ID autoincremental
CREATE TABLE dbo.map_clientes (
    id_map_cliente INT IDENTITY(1,1) PRIMARY KEY,
    nombre_informal_excel VARCHAR(150) NOT NULL,
    id_tercero_oficial INT NOT NULL,
    observaciones VARCHAR(255) NULL,
    created_at DATETIME DEFAULT GETDATE()
);
GO

PRINT 'Tabla map_clientes creada exitosamente con IDENTITY en consultora_pymes_core.';
GO
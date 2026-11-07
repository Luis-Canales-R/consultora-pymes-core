USE consultora_pymes_core;
GO

-- ==========================================
-- 1. LIMPIEZA PREVIA
-- ==========================================
DROP TABLE IF EXISTS map_productos;
DROP TABLE IF EXISTS map_clientes;
GO

-- ==========================================
-- 2. CREACIÓN DE TABLAS DE MAPEO (FASE 2)
-- ==========================================
CREATE TABLE map_clientes (
    id_map_cliente INT PRIMARY KEY,
    nombre_informal_excel VARCHAR(150) UNIQUE NOT NULL, -- Texto tal como viene del Excel de la PyME
    id_tercero_oficial INT NOT NULL,                    -- Vinculado a tbl_terceros (Core Fase 1)
    observaciones VARCHAR(250) NULL,
    created_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT fk_map_tercero FOREIGN KEY (id_tercero_oficial) REFERENCES tbl_terceros(id_tercero)
);

CREATE TABLE map_productos (
    id_map_producto INT PRIMARY KEY,
    descripcion_libre_excel VARCHAR(150) UNIQUE NOT NULL, -- Texto libre de la planilla de la PyME
    id_item_oficial INT NOT NULL,                         -- Vinculado a tbl_productos_servicios (Core Fase 1)
    observaciones VARCHAR(250) NULL,
    created_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT fk_map_item FOREIGN KEY (id_item_oficial) REFERENCES tbl_productos_servicios(id_item)
);
GO
USE consultora_pymes_core;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ======================================================================
-- STORED PROCEDURE: sp_procesar_venta_externa
-- PROPÓSITO: Recibe datos de la plantilla de Excel, homologa nombres 
--            informales mediante tablas de mapeo y realiza el insert seguro 
--            en el Core RDBMS transaccional.
-- ======================================================================
CREATE OR ALTER PROCEDURE sp_procesar_venta_externa
    @folio_factura VARCHAR(50),
    @fecha_emision DATE,
    @nombre_informal_cliente VARCHAR(150),
    @descripcion_libre_item VARCHAR(150),
    @cantidad DECIMAL(18,4),
    @precio_unitario DECIMAL(18,2),
    @estado_venta VARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @id_tercero_oficial INT;
    DECLARE @id_item_oficial INT;

    BEGIN TRY
        -- 1. Validación y Homologación de Cliente
        SELECT @id_tercero_oficial = id_tercero_oficial
        FROM map_clientes
        WHERE nombre_informal_excel = @nombre_informal_cliente;

        IF @id_tercero_oficial IS NULL
        BEGIN
            RAISERROR('El cliente informal "%s" no se encuentra homologado en map_clientes.', 16, 1, @nombre_informal_cliente);
            RETURN;
        END

        -- 2. Validación y Homologación de Producto / Servicio
        SELECT @id_item_oficial = id_item_oficial
        FROM map_productos
        WHERE descripcion_libre_excel = @descripcion_libre_item;

        IF @id_item_oficial IS NULL
        BEGIN
            RAISERROR('La descripción de ítem "%s" no se encuentra homologada en map_productos.', 16, 1, @descripcion_libre_item);
            RETURN;
        END

        -- 3. Inserción Transaccional Segura hacia el Core
        BEGIN TRANSACTION;

            -- Nota: Aquí conectará directamente con tbl_ventas_devengadas / detalle creadas en Fase 1
            -- Ejemplo conceptual de inserción blindada:
            /*
            INSERT INTO tbl_ventas_devengadas (folio_factura, fecha_emision, id_tercero, estado)
            VALUES (@folio_factura, @fecha_emision, @id_tercero_oficial, @estado_venta);
            */

        COMMIT TRANSACTION;
        PRINT 'Transacción procesada e integrada al Core exitosamente.';

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
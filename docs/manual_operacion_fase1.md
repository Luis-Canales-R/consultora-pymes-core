# Manual de Operación y Arquitectura - Fase 1 (Core RDBMS PyMEs)

## 1. Propósito del Sistema
El **Core RDBMS de la Consultora** representa el estado canónico ideal para la gestión operativa y financiera de una PyME. Su diseño relacional en Tercera Forma Normal (3FN) desacopla la lógica de negocio de los registros transaccionales, garantizando trazabilidad, integridad referencial estricta y cumplimiento con los estándares tributarios y contables locales (Chile/IFRS).

---

## 2. Estructura y Módulos de la Fase 1

El modelo se divide en cuatro grandes pilares interconectados:

### A. Módulo de Terceros (Clientes y Proveedores)
* **Objetivo:** Centraliza la identidad fiscal, comercial y de contacto de todas las entidades externas que interactúan con la empresa.
* **Componentes Clave:** 
  * Datos fiscales (RUT, razón social, dirección).
  * Condiciones de crédito y plazos de pago.

### B. Módulo de Productos, Servicios y Composición (BOM / CBS)
* **Objetivo:** Estandarizar la oferta comercial combinando productos tangibles con servicios profesionales mediante el Patrón de Extensión ERP (1:1) y estructuras de costos modulares.
* **Componentes Clave:**
  * `tbl_productos_servicios`: Cabecera unificada (SKU, nombre, precio base).
  * `tbl_item_extension_producto` & `tbl_item_extension_servicio`: Tablas 1:1 para atributos logísticos o de SLA.
  * `tbl_item_composicion_hh` & `tbl_item_composicion_insumos`: Estructura BOM/CBS para calcular automáticamente el costo total y el margen de contribución a través de la vista `vw_productos_servicios_costeo`.

### C. Módulo Contable, Transaccional y Partida Doble
* **Objetivo:** Automatizar el registro de hechos económicos garantizando la ecuación contable estricta ($Debe = Haber$) y separando conceptualmente el **Devengado** de la **Liquidación (Flujo de Caja)**.
* **Componentes Clave:**
  * `cat_plan_cuentas`: Carga masiva jerárquica del plan de cuentas estándar Chile (Activo, Pasivo, Patrimonio, Ingresos, Costos, Gastos).
  * `tbl_transacciones_cabecera`: Respaldo comercial y tributario (Facturas, boletas).
  * `tbl_asientos_cabecera` y `tbl_asientos_detalle`: Motor de partida doble.

### D. Módulo de Organización y Control (Centros de Costo y Empleados)
* **Objetivo:** Aportar las dimensiones organizacionales para el control de gestión (alineado con la taxonomía APQC) y la trazabilidad operativa.
* **Componentes Clave:**
  * `tbl_centros_costo`: Jerarquía de áreas (Finanzas, Operaciones, Ventas, etc.).
  * `tbl_empleados_usuarios`: Registro de colaboradores vinculados a su respectivo centro de costo.

---

## 3. Instructivo de Despliegue y Validación en SQL Server

Para desplegar o levantar el ecosistema completo desde cero en una nueva instancia de base de datos (`consultora_pymes_core`), se debe seguir estrictamente este orden de ejecución de scripts en **SQL Server Management Studio (SSMS)**:

1. **Creación del Plan de Cuentas y Motor Contable** (`sql/crear_modulo_contabilidad_transacciones.sql`): Levanta las tablas maestras contables y el catálogo de cuentas de Chile.
2. **Creación del Módulo de Productos, Servicios y BOM** (`sql/crear_modulo_productos_servicios.sql`): Despliega la cabecera de ítems, extensiones ERP y la vista de costeo.
3. **Creación de Centros de Costo y Empleados** (`sql/crear_modulo_centros_costo_empleados.sql`): Configura la estructura organizacional y los usuarios.

### Verificación de Integridad y Cuadratura
Todo ciclo transaccional debe finalizar validando la cuadratura de los asientos contables ejecutando la consulta de control:
```sql
SELECT 
    a.numero_asiento,
    SUM(d.debe) AS total_debe,
    SUM(d.haber) AS total_haber,
    CASE WHEN SUM(d.debe) = SUM(d.haber) THEN 'CUADRADO (PARTIDA DOBLE OK)' ELSE 'DESCUADRADO' END AS estado_cuadratura
FROM tbl_asientos_cabecera a
INNER JOIN tbl_asientos_detalle d ON a.id_asiento = d.id_asiento
GROUP BY a.numero_asiento, a.fecha_asiento, a.glosa_general;
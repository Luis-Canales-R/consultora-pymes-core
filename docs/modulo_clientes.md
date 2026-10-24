# Módulo de Clientes y Catálogos Base

## Descripción General
Este módulo gestiona la información centralizada de los clientes de la consultora, asegurando la normalización mediante catálogos relacionales en estructura 3NF.

## Tablas del Módulo

### 1. `cat_paises`
Catálogo internacional de países basado en normas ISO.
- `id_pais`: Identificador único (Primary Key).
- `codigo_iso`: Código ISO de 3 dígitos (Ej: CHL, PER, ARG).
- `nombre_pais`: Nombre oficial del país.

### 2. `cat_condiciones_pago`
Define los plazos y modalidades comerciales de cobro.
- `id_condicion_pago`: Identificador único (Primary Key).
- `codigo`: Código corto de la condición (Ej: CONTADO, 30_DIAS).
- `descripcion`: Detalle de la condición comercial.
- `dias`: Cantidad numérica de días asociados al plazo.

### 3. `cat_tipos_persona`
Clasificación legal de la entidad de negocio.
- `id_tipo_persona`: Identificador único (Primary Key).
- `codigo`: Código interno (Ej: NATURAL, JURIDICA).
- `nombre`: Nombre descriptivo del tipo de persona.

### 4. `cat_tipos_cliente_negocio`
Segmentación comercial del cliente para control de gestión.
- `id_tipo_cliente_negocio`: Identificador único (Primary Key).
- `codigo`: Código de categoría.
- `nombre`: Descripción de la segmentación.

### 5. `tbl_clientes`
Tabla maestra que almacena el registro principal de cada cliente.
- Relacionada mediante llaves foráneas con los cuatro catálogos anteriores para garantizar integridad referencial y estandarización de datos.
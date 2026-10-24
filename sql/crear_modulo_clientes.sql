-- ==========================================
-- SCRIPT DE CREACIÓN: MÓDULO DE CLIENTES Y CATÁLOGOS
-- ==========================================

CREATE TABLE cat_paises (
    id_pais INT PRIMARY KEY,
    codigo_iso VARCHAR(3) UNIQUE NOT NULL,
    nombre_pais VARCHAR(100) NOT NULL
);

CREATE TABLE cat_condiciones_pago (
    id_condicion_pago INT PRIMARY KEY,
    codigo VARCHAR(50) UNIQUE NOT NULL,
    descripcion VARCHAR(100) NOT NULL,
    dias INT NOT NULL
);

CREATE TABLE cat_tipos_persona (
    id_tipo_persona INT PRIMARY KEY,
    codigo VARCHAR(20) UNIQUE NOT NULL,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE cat_tipos_cliente_negocio (
    id_tipo_cliente_negocio INT PRIMARY KEY,
    codigo VARCHAR(50) UNIQUE NOT NULL,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE tbl_clientes (
    id_cliente INT PRIMARY KEY,
    codigo_cliente VARCHAR(50) UNIQUE NOT NULL,
    id_tipo_persona INT NOT NULL,
    nombre_razon_social VARCHAR(200) NOT NULL,
    nombre_fantasia VARCHAR(150),
    rut_dni VARCHAR(20) UNIQUE NOT NULL,
    direccion VARCHAR(250),
    comuna_ciudad VARCHAR(100),
    id_pais INT NOT NULL,
    id_tipo_cliente_negocio INT NOT NULL,
    id_condicion_pago INT NOT NULL,
    contacto_nombre VARCHAR(100),
    contacto_email VARCHAR(100),
    estado_activo BOOLEAN,
    created_at TIMESTAMP,
    CONSTRAINT fk_cliente_tipo_persona FOREIGN KEY (id_tipo_persona) REFERENCES cat_tipos_persona(id_tipo_persona),
    CONSTRAINT fk_cliente_pais FOREIGN KEY (id_pais) REFERENCES cat_paises(id_pais),
    CONSTRAINT fk_cliente_tipo_negocio FOREIGN KEY (id_tipo_cliente_negocio) REFERENCES cat_tipos_cliente_negocio(id_tipo_cliente_negocio),
    CONSTRAINT fk_cliente_condicion_pago FOREIGN KEY (id_condicion_pago) REFERENCES cat_condiciones_pago(id_condicion_pago)
);
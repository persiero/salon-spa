-- ==========================================================
-- SISTEMA: Salón de Belleza / Facturación Electrónica (Perú)
-- ARCHIVO: schema_completo_v1.sql
-- FECHA: 2026
-- DESCRIPCIÓN: Estructura completa + Datos iniciales (Seeds)
-- ==========================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------------------------------------
-- 1. TABLAS BASE (Usuarios, Roles, Clientes)
-- ----------------------------------------------------------

DROP TABLE IF EXISTS usuarios;
DROP TABLE IF EXISTS roles;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS estilistas;

CREATE TABLE roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255) NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    UNIQUE(nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_rol INT NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL,
    password VARCHAR(255) NOT NULL,
    activo TINYINT(1) NOT NULL DEFAULT 1,
    remember_token VARCHAR(100) NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    CONSTRAINT fk_usuarios_roles FOREIGN KEY (id_rol)
        REFERENCES roles(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    UNIQUE(email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    apellido VARCHAR(150) NULL,
    tipo_documento VARCHAR(20) NULL, -- Ej: 1 (DNI), 6 (RUC)
    numero_documento VARCHAR(20) NULL,
    direccion VARCHAR(255) NULL,
    telefono VARCHAR(50) NULL,
    email VARCHAR(150) NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    deleted_at TIMESTAMP NULL, -- Soft Delete
    INDEX idx_cliente_doc (numero_documento),
    INDEX idx_cliente_nombre (nombre, apellido)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE estilistas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    especialidad VARCHAR(150) NULL,
    telefono VARCHAR(50) NULL,
    activo TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    deleted_at TIMESTAMP NULL -- Soft Delete
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------
-- 2. CATÁLOGOS Y CONFIGURACIÓN
-- ----------------------------------------------------------

DROP TABLE IF EXISTS config_tributaria;
DROP TABLE IF EXISTS config_negocio;
DROP TABLE IF EXISTS unidades_sunat;
DROP TABLE IF EXISTS afectaciones_igv;
DROP TABLE IF EXISTS estados_comprobante;
DROP TABLE IF EXISTS tipos_comprobante;
DROP TABLE IF EXISTS metodos_pago;

CREATE TABLE metodos_pago (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(255) NULL,
    activo TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE tipos_comprobante (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codigo_sunat VARCHAR(2) NOT NULL,
    descripcion VARCHAR(100) NOT NULL,
    tributario TINYINT(1) NOT NULL DEFAULT 1,
    UNIQUE(codigo_sunat),
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE estados_comprobante (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(255) NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE afectaciones_igv (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codigo_sunat VARCHAR(2) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    gravado TINYINT(1) NOT NULL DEFAULT 0,
    porcentaje_igv DECIMAL(5,2) NULL,
    UNIQUE(codigo_sunat),
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE unidades_sunat (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codigo_sunat VARCHAR(5) NOT NULL UNIQUE,
    descripcion VARCHAR(100) NOT NULL,
    tipo VARCHAR(50) NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE config_negocio (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_comercial VARCHAR(255) NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    telefono VARCHAR(50) NULL,
    email VARCHAR(150) NULL,
    ruc VARCHAR(11) NULL,
    precio_incluye_igv TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE config_tributaria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    igv_porcentaje DECIMAL(5,2) NOT NULL DEFAULT 18.00,
    emision_automatica_cpe TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------
-- 3. NEGOCIO (Servicios y Turnos)
-- ----------------------------------------------------------

DROP TABLE IF EXISTS turno_servicio;
DROP TABLE IF EXISTS turnos;
DROP TABLE IF EXISTS servicios;
DROP TABLE IF EXISTS categorias_servicio;

CREATE TABLE categorias_servicio (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL UNIQUE,
    descripcion VARCHAR(255) NULL,
    activo TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    deleted_at TIMESTAMP NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE servicios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_categoria_servicio INT NULL,
    id_afectacion_igv INT NOT NULL,
    id_unidad_sunat INT NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    duracion_minutos INT NULL,
    activo TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    deleted_at TIMESTAMP NULL,
    
    CONSTRAINT fk_servicio_categoria FOREIGN KEY (id_categoria_servicio)
        REFERENCES categorias_servicio(id) ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_servicio_afectacion FOREIGN KEY (id_afectacion_igv)
        REFERENCES afectaciones_igv(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_servicio_unidad FOREIGN KEY (id_unidad_sunat)
        REFERENCES unidades_sunat(id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE turnos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_estilista INT NOT NULL,
    fecha_inicio DATETIME NOT NULL,
    fecha_fin DATETIME NULL,
    estado VARCHAR(30) NOT NULL DEFAULT 'en_atencion',
    observaciones TEXT NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    
    CONSTRAINT fk_turno_cliente FOREIGN KEY (id_cliente)
        REFERENCES clientes(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_turno_estilista FOREIGN KEY (id_estilista)
        REFERENCES estilistas(id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE turno_servicio (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_turno INT NOT NULL,
    id_servicio INT NOT NULL,
    precio_aplicado DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    
    CONSTRAINT fk_turno_servicio_turno FOREIGN KEY (id_turno)
        REFERENCES turnos(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_turno_servicio_servicio FOREIGN KEY (id_servicio)
        REFERENCES servicios(id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------
-- 4. INVENTARIO
-- ----------------------------------------------------------

DROP TABLE IF EXISTS movimientos_inventario;
DROP TABLE IF EXISTS productos;

CREATE TABLE productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_afectacion_igv INT NOT NULL,
    id_unidad_sunat INT NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    descripcion VARCHAR(255) NULL,
    precio DECIMAL(10,2) NOT NULL,
    stock_actual INT NOT NULL DEFAULT 0,
    stock_minimo INT NOT NULL DEFAULT 0,
    activo TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    deleted_at TIMESTAMP NULL,
    
    CONSTRAINT fk_producto_afectacion FOREIGN KEY (id_afectacion_igv)
        REFERENCES afectaciones_igv(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_producto_unidad FOREIGN KEY (id_unidad_sunat)
        REFERENCES unidades_sunat(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    INDEX idx_producto_nombre (nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE movimientos_inventario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_producto INT NOT NULL,
    id_usuario INT NULL,
    tipo ENUM('entrada','salida_venta','salida_consumo','ajuste') NOT NULL,
    cantidad INT NOT NULL,
    motivo VARCHAR(255) NULL,
    referencia VARCHAR(100) NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    
    CONSTRAINT fk_mov_productos FOREIGN KEY (id_producto)
        REFERENCES productos(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_mov_usuarios FOREIGN KEY (id_usuario)
        REFERENCES usuarios(id) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------
-- 5. VENTAS Y CAJA (Con Snapshots)
-- ----------------------------------------------------------

DROP TABLE IF EXISTS pagos;
DROP TABLE IF EXISTS detalles_venta;
DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS cajas;

CREATE TABLE cajas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario_apertura INT NOT NULL,
    id_usuario_cierre INT NULL,
    fecha_apertura DATETIME NOT NULL,
    fecha_cierre DATETIME NULL,
    monto_apertura DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    monto_cierre DECIMAL(10,2) NULL,
    estado ENUM('abierta','cerrada') NOT NULL DEFAULT 'abierta',
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    
    CONSTRAINT fk_caja_usuario_ap FOREIGN KEY (id_usuario_apertura)
        REFERENCES usuarios(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_caja_usuario_ci FOREIGN KEY (id_usuario_cierre)
        REFERENCES usuarios(id) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE ventas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NULL,
    id_turno INT NULL,
    id_caja INT NOT NULL,
    fecha DATETIME NOT NULL,
    
    -- Totales Globales (SNAPSHOT para reportes rápidos)
    op_gravadas DECIMAL(10,2) DEFAULT 0.00,
    op_exoneradas DECIMAL(10,2) DEFAULT 0.00,
    op_inafectas DECIMAL(10,2) DEFAULT 0.00,
    monto_igv DECIMAL(10,2) DEFAULT 0.00,
    total DECIMAL(10,2) NOT NULL,
    
    estado ENUM('pagada','anulada') NOT NULL DEFAULT 'pagada',
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    
    CONSTRAINT fk_venta_cliente FOREIGN KEY (id_cliente)
        REFERENCES clientes(id) ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_venta_turno FOREIGN KEY (id_turno)
        REFERENCES turnos(id) ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_venta_caja FOREIGN KEY (id_caja)
        REFERENCES cajas(id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE detalles_venta (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_venta INT NOT NULL,
    tipo_item ENUM('servicio','producto') NOT NULL,
    
    id_servicio INT NULL,
    id_producto INT NULL,
    
    -- SNAPSHOT DEL ITEM (Inmutabilidad)
    nombre_item VARCHAR(255) NOT NULL, 
    codigo_afectacion_igv VARCHAR(10) NOT NULL,
    porcentaje_igv DECIMAL(5,2) NOT NULL,
    codigo_unidad_medida VARCHAR(10) NOT NULL,
    
    cantidad INT NOT NULL DEFAULT 1,
    valor_unitario DECIMAL(10,2) NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    
    igv_total_linea DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    
    CONSTRAINT fk_det_venta FOREIGN KEY (id_venta)
        REFERENCES ventas(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_det_servicio FOREIGN KEY (id_servicio)
        REFERENCES servicios(id) ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_det_producto FOREIGN KEY (id_producto)
        REFERENCES productos(id) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE pagos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_venta INT NOT NULL,
    id_metodo_pago INT NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    referencia VARCHAR(100) NULL,
    fecha DATETIME NOT NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    
    CONSTRAINT fk_pago_venta FOREIGN KEY (id_venta)
        REFERENCES ventas(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_pago_metodo FOREIGN KEY (id_metodo_pago)
        REFERENCES metodos_pago(id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------
-- 6. TRIBUTARIO (CPE) - Con Snapshots de Receptor
-- ----------------------------------------------------------

DROP TABLE IF EXISTS comunicacion_baja;
DROP TABLE IF EXISTS envios_ose;
DROP TABLE IF EXISTS comprobantes;
DROP TABLE IF EXISTS series_comprobante;

CREATE TABLE series_comprobante (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_tipo_comprobante INT NOT NULL,
    serie VARCHAR(4) NOT NULL,
    correlativo_actual INT NOT NULL DEFAULT 0,
    activo TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    
    CONSTRAINT fk_serie_tipo FOREIGN KEY (id_tipo_comprobante)
        REFERENCES tipos_comprobante(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    UNIQUE(id_tipo_comprobante, serie)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE comprobantes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_venta INT NOT NULL,
    id_tipo_comprobante INT NOT NULL,
    id_estado_comprobante INT NOT NULL,
    id_serie_comprobante INT NOT NULL,
    numero VARCHAR(20) NOT NULL,
    
    fecha_emision DATETIME NOT NULL,
    fecha_envio DATETIME NULL,
    
    -- SNAPSHOT DEL RECEPTOR (Cliente)
    receptor_tipo_doc VARCHAR(20) NULL,
    receptor_numero_doc VARCHAR(20) NULL,
    receptor_razon_social VARCHAR(255) NULL,
    receptor_direccion VARCHAR(255) NULL,
    
    xml_firmado MEDIUMTEXT NULL,
    cdr_sunat MEDIUMTEXT NULL,
    hash VARCHAR(255) NULL,
    qr TEXT NULL,
    
    total_operaciones_gravadas DECIMAL(10,2) NULL,
    total_operaciones_exoneradas DECIMAL(10,2) NULL,
    total_operaciones_inafectas DECIMAL(10,2) NULL,
    total_igv DECIMAL(10,2) NULL,
    total_venta DECIMAL(10,2) NOT NULL,
    
    contingencia TINYINT(1) NOT NULL DEFAULT 0,
    observaciones TEXT NULL,
    
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    
    CONSTRAINT fk_cpe_venta FOREIGN KEY (id_venta)
        REFERENCES ventas(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_cpe_tipo FOREIGN KEY (id_tipo_comprobante)
        REFERENCES tipos_comprobante(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_cpe_estado FOREIGN KEY (id_estado_comprobante)
        REFERENCES estados_comprobante(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_cpe_serie FOREIGN KEY (id_serie_comprobante)
        REFERENCES series_comprobante(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    UNIQUE(numero)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE envios_ose (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_comprobante INT NOT NULL,
    fecha_envio DATETIME NOT NULL,
    fecha_respuesta DATETIME NULL,
    estado VARCHAR(50) NOT NULL,
    mensaje TEXT NULL,
    reintentos INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    
    CONSTRAINT fk_envio_cpe FOREIGN KEY (id_comprobante)
        REFERENCES comprobantes(id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE comunicacion_baja (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_comprobante INT NOT NULL,
    fecha_comunicacion DATETIME NOT NULL,
    ticket_sunat VARCHAR(100) NULL,
    estado VARCHAR(50) NOT NULL DEFAULT 'pendiente',
    motivo TEXT NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    
    CONSTRAINT fk_baja_cpe FOREIGN KEY (id_comprobante)
        REFERENCES comprobantes(id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ----------------------------------------------------------
-- 7. INTEGRACIÓN PSE (Proveedores de Servicios Electrónicos)
-- ----------------------------------------------------------

DROP TABLE IF EXISTS pse_logs;
DROP TABLE IF EXISTS pse_endpoints;
DROP TABLE IF EXISTS pse_credenciales;
DROP TABLE IF EXISTS pse_proveedores;

CREATE TABLE pse_proveedores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255) NULL,
    activo TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE pse_credenciales (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_pse_proveedor INT NOT NULL,
    ambiente ENUM('sandbox','produccion') NOT NULL DEFAULT 'sandbox',
    usuario VARCHAR(255) NULL,
    password VARCHAR(255) NULL,
    token TEXT NULL,
    fecha_expiracion DATETIME NULL,
    activo TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    
    CONSTRAINT fk_pse_cred_prov FOREIGN KEY (id_pse_proveedor)
        REFERENCES pse_proveedores(id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE pse_endpoints (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_pse_proveedor INT NOT NULL,
    ambiente ENUM('sandbox','produccion') NOT NULL DEFAULT 'sandbox',
    url_emision VARCHAR(255) NOT NULL,
    url_consulta VARCHAR(255) NULL,
    url_baja VARCHAR(255) NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    
    CONSTRAINT fk_pse_end_prov FOREIGN KEY (id_pse_proveedor)
        REFERENCES pse_proveedores(id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE pse_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_comprobante INT NOT NULL,
    id_pse_proveedor INT NOT NULL,
    endpoint VARCHAR(255) NOT NULL,
    payload LONGTEXT NULL,     -- JSON enviado
    respuesta LONGTEXT NULL,   -- JSON recibido
    exito TINYINT(1) NOT NULL,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_logs_cpe FOREIGN KEY (id_comprobante)
        REFERENCES comprobantes(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_logs_prov FOREIGN KEY (id_pse_proveedor)
        REFERENCES pse_proveedores(id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------
-- 8. SEEDS (Datos Iniciales)
-- ----------------------------------------------------------

-- Roles
INSERT INTO roles (nombre, descripcion, created_at) VALUES
('administrador', 'Acceso completo al sistema', NOW()),
('encargado', 'Gestiona turnos y catálogo', NOW()),
('cajero', 'Gestiona caja y cobros', NOW());

-- Métodos de pago
INSERT INTO metodos_pago (nombre, descripcion, created_at) VALUES
('efectivo', 'Pago en efectivo', NOW()),
('tarjeta', 'Pago con tarjeta', NOW()),
('yape', 'Pago mediante Yape', NOW()),
('plin', 'Pago mediante Plin', NOW()),
('transferencia', 'Transferencia bancaria', NOW());

-- Tipos Comprobante
INSERT INTO tipos_comprobante (codigo_sunat, descripcion, tributario, created_at) VALUES
('01', 'Factura', 1, NOW()),
('03', 'Boleta', 1, NOW()),
('00', 'Ticket Interno', 0, NOW());

-- Estados Comprobante
INSERT INTO estados_comprobante (nombre, descripcion, created_at) VALUES
('emitido', 'Emitido localmente', NOW()),
('pendiente_envio', 'Generado, pendiente de envío al OSE', NOW()),
('enviado', 'Enviado al OSE', NOW()),
('aceptado', 'Aceptado por SUNAT', NOW()),
('rechazado', 'Rechazado por SUNAT', NOW()),
('anulado', 'Anulado legalmente', NOW());

-- Afectaciones IGV
INSERT INTO afectaciones_igv (codigo_sunat, nombre, gravado, porcentaje_igv, created_at) VALUES
('10', 'Gravado - Operación Onerosa', 1, 18.00, NOW()),
('20', 'Exonerado', 0, 0.00, NOW()),
('30', 'Inafecto', 0, 0.00, NOW()),
('31', 'Exportación', 0, 0.00, NOW()),
('32', 'Gratuito', 0, 18.00, NOW());

-- Unidades SUNAT
INSERT INTO unidades_sunat (codigo_sunat, descripcion, tipo, created_at) VALUES
('ZZ', 'Servicio', 'Servicio', NOW()),
('NIU', 'Unidad', 'Producto', NOW());

-- Configuración Base
INSERT INTO config_negocio (nombre_comercial, direccion, precio_incluye_igv, created_at)
VALUES ('SALON BELLEZA', 'DIRECCIÓN POR CONFIGURAR', 1, NOW());

INSERT INTO config_tributaria (igv_porcentaje, emision_automatica_cpe, created_at)
VALUES (18.00, 1, NOW());

-- Proveedor PSE Default
INSERT INTO pse_proveedores (nombre, descripcion, created_at)
VALUES ('PSE_POR_DEFINIR', 'Proveedor PSE pendiente de configuración', NOW());

SET FOREIGN_KEY_CHECKS = 1;
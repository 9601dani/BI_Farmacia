CREATE DATABASE IF NOT EXISTS farmacia_BI;
USE farmacia_BI;

CREATE USER IF NOT EXISTS 'dani_bi'@'localhost' IDENTIFIED BY 'bi_2025';
GRANT ALL PRIVILEGES ON farmacia_BI.* TO 'dani_bi'@'localhost';
FLUSH PRIVILEGES;


-- ODS: Sistema de Ventas por Sucursal
CREATE TABLE IF NOT EXISTS region (
  id_region VARCHAR(10) PRIMARY KEY,
  nombre_region VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS departamento (
  id_departamento VARCHAR(10) PRIMARY KEY,
  nombre_departamento VARCHAR(100),
  id_region VARCHAR(10),
  FOREIGN KEY (id_region) REFERENCES region(id_region)
);

CREATE TABLE IF NOT EXISTS municipio (
  id_municipio VARCHAR(10) PRIMARY KEY,
  nombre_municipio VARCHAR(100),
  id_departamento VARCHAR(10),
  FOREIGN KEY (id_departamento) REFERENCES departamento(id_departamento)
);

CREATE TABLE IF NOT EXISTS sucursal (
  id_sucursal VARCHAR(10) PRIMARY KEY,
  nombre_sucursal VARCHAR(100),
  ubicacion VARCHAR(150),
  id_municipio VARCHAR(10),
  FOREIGN KEY (id_municipio) REFERENCES municipio(id_municipio)
);

CREATE TABLE IF NOT EXISTS jornada (
  id_jornada VARCHAR(10) PRIMARY KEY,
  tipo_jornada VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS empleado (
  id_empleado VARCHAR(10) PRIMARY KEY,
  nombre VARCHAR(100),
  cargo VARCHAR(50),
  dpi VARCHAR(20),
  edad INT,
  genero CHAR(1),
  fecha_ingreso DATE,
  estado_empleado VARCHAR(50),
  id_jornada VARCHAR(10),
  id_sucursal VARCHAR(10),
  FOREIGN KEY (id_jornada) REFERENCES jornada(id_jornada),
  FOREIGN KEY (id_sucursal) REFERENCES sucursal(id_sucursal)
);

CREATE TABLE IF NOT EXISTS categoria (
  id_categoria VARCHAR(10) PRIMARY KEY,
  nombre_categoria VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS producto (
  id_producto VARCHAR(10) PRIMARY KEY,
  nombre VARCHAR(100),
  id_categoria VARCHAR(10),
  marca VARCHAR(50),
  presentacion VARCHAR(50),
  precio_base DECIMAL(10,2),
  es_propio BOOLEAN,
  unidad_de_medida VARCHAR(20),
  FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
);

CREATE TABLE IF NOT EXISTS cliente (
  id_cliente VARCHAR(10) PRIMARY KEY,
  nit VARCHAR(20),
  nombre VARCHAR(100),
  tipo_cliente VARCHAR(50),
  genero CHAR(1),
  edad INT,
  numero_de_compras INT,
  frecuencia_compra VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS venta (
  id_venta INT PRIMARY KEY,
  fecha_venta DATE,
  hora_venta TIME,
  id_sucursal VARCHAR(10),
  id_empleado VARCHAR(10),
  total_bruto DECIMAL(10,2),
  id_cliente VARCHAR(10),
  canal_venta VARCHAR(50),
  descuento_total DECIMAL(10,2),
  total_neto DECIMAL(10,2),
  forma_pago VARCHAR(50),
  estado_pago VARCHAR(50),
  FOREIGN KEY (id_sucursal) REFERENCES sucursal(id_sucursal),
  FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado),
  FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

CREATE TABLE IF NOT EXISTS detalle_venta (
  id_detalle INT PRIMARY KEY,
  id_venta INT,
  id_producto VARCHAR(10),
  cantidad_vendida INT,
  precio_unitario DECIMAL(10,2),
  margen_unitario DECIMAL(10,2),
  subtotal DECIMAL(10,2),
  descuento_producto DECIMAL(10,2),
  total_linea DECIMAL(10,2),
  FOREIGN KEY (id_venta) REFERENCES venta(id_venta),
  FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

-- ODS: Sistema de Pedidos de Sucursales
CREATE TABLE IF NOT EXISTS pedido (
  id_pedido INT PRIMARY KEY,
  id_sucursal VARCHAR(10),
  fecha_solicitud DATE,
  fecha_estimada_entrega DATE,
  urgencia VARCHAR(50),
  estado VARCHAR(50),
  observaciones TEXT,
  FOREIGN KEY (id_sucursal) REFERENCES sucursal(id_sucursal)
);

CREATE TABLE IF NOT EXISTS detalle_pedido (
  id_detalle_pedido INT PRIMARY KEY,
  id_pedido INT,
  id_producto VARCHAR(10),
  cantidad_solicitada INT,
  cantidad_entregada INT,
  FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
  FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

-- ODS: Sistema de Compras
CREATE TABLE IF NOT EXISTS proveedor (
  id_proveedor VARCHAR(10) PRIMARY KEY,
  nombre VARCHAR(100),
  pais VARCHAR(50),
  canal_contacto VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS compra (
  id_compra INT PRIMARY KEY,
  id_proveedor VARCHAR(10),
  fecha_cotizacion DATE,
  fecha_orden DATE,
  fecha_estimada_entrega DATE,
  fecha_real_entrega DATE,
  estado VARCHAR(50),
  FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor)
);

CREATE TABLE IF NOT EXISTS detalle_compra (
  id_detalle_compra INT PRIMARY KEY,
  id_compra INT,
  id_producto VARCHAR(10),
  cantidad INT,
  precio_unitario DECIMAL(10,2),
  condiciones TEXT,
  FOREIGN KEY (id_compra) REFERENCES compra(id_compra),
  FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

-- ODS: Inventario General
CREATE TABLE IF NOT EXISTS ubicacion_bodega (
  id_ubicacion VARCHAR(10) PRIMARY KEY,
  descripcion VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS lote (
  id_lote VARCHAR(10) PRIMARY KEY,
  id_producto VARCHAR(10),
  id_proveedor VARCHAR(10),
  fecha_ingreso DATE,
  fecha_vencimiento DATE,
  cantidad_total INT,
  cantidad_disponible INT,
  id_ubicacion VARCHAR(10),
  FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
  FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor),
  FOREIGN KEY (id_ubicacion) REFERENCES ubicacion_bodega(id_ubicacion)
);

-- ODS: Distribucion y Logistica
CREATE TABLE IF NOT EXISTS vehiculo (
  id_vehiculo VARCHAR(10) PRIMARY KEY,
  marca VARCHAR(50),
  modelo VARCHAR(50),
  anio INT,
  capacidad_kg DECIMAL(10,2),
  rendimiento_kmgl_carretera DECIMAL(10,2),
  rendimiento_kmgl_ciudad DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS piloto (
  id_piloto VARCHAR(10) PRIMARY KEY,
  nombre VARCHAR(100),
  licencia VARCHAR(20),
  telefono VARCHAR(20),
  correo VARCHAR(100),
  fecha_ingreso DATE,
  estado VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS envio (
  id_envio INT PRIMARY KEY,
  id_pedido INT,
  id_vehiculo VARCHAR(10),
  id_piloto VARCHAR(10),
  fecha_salida DATE,
  fecha_entrega DATE,
  ruta VARCHAR(150),
  estado VARCHAR(50),
  FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
  FOREIGN KEY (id_vehiculo) REFERENCES vehiculo(id_vehiculo),
  FOREIGN KEY (id_piloto) REFERENCES piloto(id_piloto)
);

-- ODS: Producción
CREATE TABLE IF NOT EXISTS laboratorio (
  id_laboratorio VARCHAR(10) PRIMARY KEY,
  nombre VARCHAR(100),
  id_region VARCHAR(10),
  ubicacion VARCHAR(150),
  FOREIGN KEY (id_region) REFERENCES region(id_region)
);

CREATE TABLE IF NOT EXISTS produccion (
  id_produccion INT PRIMARY KEY,
  id_producto VARCHAR(10),
  id_laboratorio VARCHAR(10),
  fecha_inicio DATE,
  fecha_fin DATE,
  cantidad_producida INT,
  id_empleado VARCHAR(10),
  FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
  FOREIGN KEY (id_laboratorio) REFERENCES laboratorio(id_laboratorio),
  FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado)
);

-- ODS: Recursos Humanos
CREATE TABLE IF NOT EXISTS asistencia (
  id_asistencia INT PRIMARY KEY,
  id_empleado VARCHAR(10),
  fecha DATE,
  turno VARCHAR(20),
  estado VARCHAR(50),
  FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado)
);

CREATE TABLE IF NOT EXISTS gestion (
  id_gestion INT PRIMARY KEY,
  id_empleado VARCHAR(10),
  fecha DATE,
  tipo_gestion VARCHAR(50),
  comentario TEXT,
  FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado)
);

-- ODS: Devoluciones e Inspección
CREATE TABLE IF NOT EXISTS motivo_dev (
  id_motivo VARCHAR(10) PRIMARY KEY,
  descripcion VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS devolucion (
  id_devolucion INT PRIMARY KEY,
  id_lote VARCHAR(10),
  id_producto VARCHAR(10),
  id_proveedor VARCHAR(10),
  fecha_inspeccion DATE,
  resultado VARCHAR(50),
  id_motivo VARCHAR(10),
  cantidad_aceptada INT,
  cantidad_rechazada INT,
  id_empleado_inspector VARCHAR(10),
  estado_reclamo VARCHAR(50),
  FOREIGN KEY (id_lote) REFERENCES lote(id_lote),
  FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
  FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor),
  FOREIGN KEY (id_motivo) REFERENCES motivo_dev(id_motivo),
  FOREIGN KEY (id_empleado_inspector) REFERENCES empleado(id_empleado)
);

CREATE TABLE IF NOT EXISTS detalle_inspeccion (
  id_detalle INT PRIMARY KEY,
  id_devolucion INT,
  criterio VARCHAR(100),
  resultado_criterio VARCHAR(50),
  observaciones TEXT,
  FOREIGN KEY (id_devolucion) REFERENCES devolucion(id_devolucion)
);

-- ODS: Promociones y Marketing
CREATE TABLE IF NOT EXISTS promocion (
  id_promocion VARCHAR(10) PRIMARY KEY,
  nombre VARCHAR(100),
  canal VARCHAR(50),
  fecha_inicio DATE,
  fecha_fin DATE,
  motivo TEXT
);

CREATE TABLE IF NOT EXISTS detalle_promocion (
  id_detalle_promocion INT PRIMARY KEY,
  id_promocion VARCHAR(10),
  id_producto VARCHAR(10),
  descuento DECIMAL(10,2),
  FOREIGN KEY (id_promocion) REFERENCES promocion(id_promocion),
  FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

CREATE TABLE IF NOT EXISTS detalle_actividad (
  id_actividad INT PRIMARY KEY,
  nombre_actividad VARCHAR(100),
  id_promocion VARCHAR(10),
  presupuesto DECIMAL(10,2),
  asistencia INT,
  compras_asociadas INT,
  FOREIGN KEY (id_promocion) REFERENCES promocion(id_promocion)
);

CREATE TABLE IF NOT EXISTS feedback (
  id_feedback INT PRIMARY KEY,
  nombre VARCHAR(100),
  edad INT,
  comentario TEXT,
  id_region VARCHAR(10),
  FOREIGN KEY (id_region) REFERENCES region(id_region)
);

-- ODS: Control de Stock por Sucursal
CREATE TABLE IF NOT EXISTS stock_sucursal (
  id_stock INT PRIMARY KEY,
  id_sucursal VARCHAR(10),
  id_producto VARCHAR(10),
  cantidad_actual INT,
  minimo INT,
  maximo INT,
  fecha_ultima_actualizacion DATE,
  FOREIGN KEY (id_sucursal) REFERENCES sucursal(id_sucursal),
  FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

CREATE TABLE IF NOT EXISTS movimiento_stock (
  id_movimiento INT PRIMARY KEY,
  id_sucursal VARCHAR(10),
  id_producto VARCHAR(10),
  tipo_movimiento VARCHAR(50),
  cantidad INT,
  fecha_movimiento DATE,
  motivo TEXT,
  FOREIGN KEY (id_sucursal) REFERENCES sucursal(id_sucursal),
  FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

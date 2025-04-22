USE farmacia_BI;

-- TABLAS DE DIMENSION ---------------------------------
CREATE TABLE IF NOT EXISTS dim_fecha (
    id_fecha SERIAL PRIMARY KEY,
    fecha DATE,
    anio INT,
    mes INT,
    dia INT,
    trimestre INT
);

CREATE TABLE IF NOT EXISTS dim_producto (
    id_producto SERIAL PRIMARY KEY,
    nombre TEXT,
    marca TEXT,
    presentacion TEXT,
    unidad_de_medida TEXT,
    es_propio BOOLEAN,
    id_categoria INT
);

CREATE TABLE IF NOT EXISTS dim_cliente (
    id_cliente SERIAL PRIMARY KEY,
    nombre TEXT,
    genero TEXT,
    edad INT,
    tipo_cliente TEXT
);

CREATE TABLE IF NOT EXISTS dim_empleado (
    id_empleado SERIAL PRIMARY KEY,
    nombre TEXT,
    cargo TEXT,
    id_sucursal INT
);

CREATE TABLE IF NOT EXISTS dim_sucursal (
    id_sucursal SERIAL PRIMARY KEY,
    nombre_sucursal TEXT,
    ubicacion TEXT
);

CREATE TABLE IF NOT EXISTS dim_proveedor (
    id_proveedor SERIAL PRIMARY KEY,
    nombre TEXT,
    pais TEXT,
    canal_contacto TEXT
);

CREATE TABLE IF NOT EXISTS dim_ubicacion_bodega (
    id_ubicacion SERIAL PRIMARY KEY,
    descripcion TEXT
);

CREATE TABLE IF NOT EXISTS dim_piloto (
    id_piloto SERIAL PRIMARY KEY,
    nombre TEXT,
    licencia TEXT,
    telefono TEXT,
    correo TEXT,
    estado TEXT
);

CREATE TABLE IF NOT EXISTS dim_vehiculo (
    id_vehiculo SERIAL PRIMARY KEY,
    modelo TEXT,
    placa TEXT,
    capacidad INT
);

CREATE TABLE IF NOT EXISTS dim_laboratorio (
    id_laboratorio SERIAL PRIMARY KEY,
    nombre TEXT,
    region TEXT
);

CREATE TABLE IF NOT EXISTS dim_jornada (
    id_jornada SERIAL PRIMARY KEY,
    tipo_jornada TEXT
);

CREATE TABLE IF NOT EXISTS dim_empleado_inspector (
    id_empleado SERIAL PRIMARY KEY,
    nombre TEXT,
    cargo TEXT,
    id_sucursal INT,
    estado_empleado TEXT
);

CREATE TABLE IF NOT EXISTS dim_motivo_devolucion (
    id_motivo SERIAL PRIMARY KEY,
    descripcion TEXT
);

CREATE TABLE IF NOT EXISTS dim_promocion (
    id_promocion SERIAL PRIMARY KEY,
    nombre TEXT,
    canal TEXT,
    motivo TEXT,
    fecha_inicio DATE,
    fecha_fin DATE
);

CREATE TABLE IF NOT EXISTS dim_actividad (
    id_actividad SERIAL PRIMARY KEY,
    nombre_actividad TEXT,
    presupuesto NUMERIC,
    asistencia INT
);


-- TABLAS DE HECHOS -------------------------------------------
CREATE TABLE IF NOT EXISTS fact_ventas (
    id_fact_venta SERIAL PRIMARY KEY,
    id_fecha INT,
    id_producto INT,
    id_cliente INT,
    id_empleado INT,
    id_sucursal INT,
    cantidad_vendida INT,
    total_bruto NUMERIC,
    descuento_total NUMERIC,
    total_neto NUMERIC
);

CREATE TABLE IF NOT EXISTS fact_inventario (
    id_fact_inventario SERIAL PRIMARY KEY,
    id_fecha INT,
    id_producto INT,
    id_proveedor INT,
    id_ubicacion INT,
    cantidad_total INT,
    cantidad_disponible INT,
    dias_antes_vencimiento INT
);

CREATE TABLE IF NOT EXISTS fact_pedidos (
    id_fact_pedido SERIAL PRIMARY KEY,
    id_fecha_solicitud INT,
    id_fecha_estimada_entrega INT,
    id_producto INT,
    id_sucursal INT,
    cantidad_solicitada INT,
    cantidad_entregada INT,
    es_urgente BOOLEAN,
    estado_pedido TEXT
);

CREATE TABLE IF NOT EXISTS fact_compras (
    id_fact_compra SERIAL PRIMARY KEY,
    id_fecha_orden INT,
    id_fecha_entrega INT,
    id_producto INT,
    id_proveedor INT,
    cantidad_comprada INT,
    precio_unitario NUMERIC,
    total_compra NUMERIC,
    estado_orden TEXT
);

CREATE TABLE IF NOT EXISTS fact_distribucion (
    id_fact_distribucion SERIAL PRIMARY KEY,
    id_fecha_salida INT,
    id_fecha_entrada INT,
    id_piloto INT,
    id_vehiculo INT,
    id_sucursal INT,
    cantidad_productos_entregados INT,
    estado_envio TEXT,
    tiempo_entrega_dias INT
);

CREATE TABLE IF NOT EXISTS fact_produccion (
    id_fact_produccion SERIAL PRIMARY KEY,
    id_fecha_inicio INT,
    id_fecha_fin INT,
    id_producto INT,
    id_empleado INT,
    id_laboratorio INT,
    cantidad_producida INT,
    duracion_dias INT
);

CREATE TABLE IF NOT EXISTS fact_rrhh (
    id_fact_rrhh SERIAL PRIMARY KEY,
    id_fecha INT,
    id_empleado INT,
    id_jornada INT,
    estado_asistencia TEXT,
    total_gestiones_dia INT,
    tipo_gestion_principal TEXT
);

CREATE TABLE IF NOT EXISTS fact_inspeccion (
    id_fact_inspeccion SERIAL PRIMARY KEY,
    id_fecha INT,
    id_producto INT,
    id_proveedor INT,
    id_empleado INT,
    id_motivo INT,
    cantidad_aceptada INT,
    cantidad_rechazada INT,
    estado_reclamo TEXT,
    resultado_final TEXT
);

CREATE TABLE IF NOT EXISTS fact_marketing (
    id_fact_marketing SERIAL PRIMARY KEY,
    id_fecha INT,
    id_producto INT,
    id_promocion INT,
    id_actividad INT,
    descuento NUMERIC,
    ventas_asociadas NUMERIC,
    feedback_positivo INT,
    feedback_negativo INT
);

CREATE TABLE IF NOT EXISTS fact_stock_sucursal (
    id_fact_stock SERIAL PRIMARY KEY,
    id_fecha INT,
    id_producto INT,
    id_sucursal INT,
    cantidad_actual INT,
    minimo INT,
    maximo INT,
    cantidad_movida INT,
    tipo_movimiento TEXT,
    motivo TEXT
);

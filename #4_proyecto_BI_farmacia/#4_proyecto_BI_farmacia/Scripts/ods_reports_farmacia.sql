USE farmacia_BI;


-- ODS: Sistema de Ventas por Sucursal
-- Reporte de ventas diarias por sucursal
SELECT fecha_venta, id_sucursal, SUM(total_neto) AS total_ventas
FROM venta
GROUP BY fecha_venta, id_sucursal;

-- Productos más vendidos por mes
SELECT DATE_FORMAT(v.fecha_venta, '%Y-%m') AS mes, dv.id_producto, SUM(dv.cantidad_vendida) AS total_vendido
FROM detalle_venta dv
JOIN venta v ON dv.id_venta = v.id_venta
GROUP BY mes, dv.id_producto
ORDER BY mes, total_vendido DESC;

-- Ventas por canal
SELECT canal_venta, COUNT(*) AS total_ventas, SUM(total_neto) AS total_ingresos
FROM venta
GROUP BY canal_venta;

-- Comparativo de ventas por género de cliente
SELECT c.genero, SUM(v.total_neto) AS total_ventas
FROM venta v
JOIN cliente c ON v.id_cliente = c.id_cliente
GROUP BY c.genero;

-- Ranking de empleados por volumen de venta
SELECT e.nombre, SUM(v.total_neto) AS total_ventas
FROM venta v
JOIN empleado e ON v.id_empleado = e.id_empleado
GROUP BY e.id_empleado
ORDER BY total_ventas DESC;

-- ODS: Sistema de Pedidos de Sucursales
-- Estado actual de pedidos por sucursal
SELECT id_sucursal, estado, COUNT(*) AS total
FROM pedido
GROUP BY id_sucursal, estado;

-- Productos más pedidos por sucursal
SELECT p.id_sucursal, dp.id_producto, SUM(dp.cantidad_solicitada) AS total_solicitado
FROM detalle_pedido dp
JOIN pedido p ON dp.id_pedido = p.id_pedido
GROUP BY p.id_sucursal, dp.id_producto
ORDER BY total_solicitado DESC;

-- Pedidos urgentes pendientes de entrega
SELECT *
FROM pedido
WHERE urgencia = 'Alta' AND estado NOT IN ('Entregado', 'Cancelado');

-- Tiempo promedio entre solicitud y entrega estimada
SELECT id_sucursal, AVG(DATEDIFF(fecha_estimada_entrega, fecha_solicitud)) AS promedio_dias
FROM pedido
GROUP BY id_sucursal;

-- ODS: Sistema de Compras
-- Compras realizadas por proveedor
SELECT id_proveedor, COUNT(*) AS total_compras, SUM(dc.cantidad * dc.precio_unitario) AS total_gastado
FROM compra c
JOIN detalle_compra dc ON c.id_compra = dc.id_compra
GROUP BY id_proveedor;

-- Comparativo de precios por producto y proveedor
SELECT id_producto, id_proveedor, AVG(precio_unitario) AS precio_promedio
FROM detalle_compra dc
JOIN compra c ON dc.id_compra = c.id_compra
GROUP BY id_producto, id_proveedor;

-- Proveedores con más devoluciones
SELECT id_proveedor, COUNT(*) AS total_devoluciones
FROM devolucion
GROUP BY id_proveedor
ORDER BY total_devoluciones DESC;

-- Órdenes de compra pendientes de entrega
SELECT * FROM compra WHERE estado NOT IN ('Entregado', 'Recibido');

-- ODS: Inventario / Bodega Central
-- Lotes próximos a vencerse
SELECT * FROM lote WHERE fecha_vencimiento <= DATE_ADD(CURDATE(), INTERVAL 30 DAY);

-- Stock disponible por producto
SELECT id_producto, SUM(cantidad_disponible) AS total_disponible
FROM lote
GROUP BY id_producto;

-- Productos con bajo nivel de inventario
SELECT id_producto, SUM(cantidad_disponible) AS disponible
FROM lote
GROUP BY id_producto
HAVING disponible < 50;

-- Trazabilidad de lote (ingreso, inspección, salida)
SELECT l.id_lote, l.fecha_ingreso, d.fecha_inspeccion, e.fecha_entrega
FROM lote l
LEFT JOIN devolucion d ON l.id_lote = d.id_lote
LEFT JOIN envio e ON l.id_lote = e.id_pedido;

-- ODS: Distribución y Logística
-- Estado de envíos en tránsito
SELECT * FROM envio WHERE estado = 'En tránsito';

-- Pedidos entregados por piloto
SELECT id_piloto, COUNT(*) AS entregas_realizadas
FROM envio
WHERE estado = 'Entregado'
GROUP BY id_piloto;

-- Vehículos con más uso
SELECT id_vehiculo, COUNT(*) AS usos
FROM envio
GROUP BY id_vehiculo
ORDER BY usos DESC;

-- Tiempos promedio de entrega por región
SELECT r.id_region, AVG(DATEDIFF(e.fecha_entrega, e.fecha_salida)) AS promedio_dias
FROM envio e
JOIN pedido p ON e.id_pedido = p.id_pedido
JOIN sucursal s ON p.id_sucursal = s.id_sucursal
JOIN municipio m ON s.id_municipio = m.id_municipio
JOIN departamento d ON m.id_departamento = d.id_departamento
JOIN region r ON d.id_region = r.id_region
GROUP BY r.id_region;

-- ODS: Producción
-- Producción por laboratorio y producto
SELECT id_laboratorio, id_producto, SUM(cantidad_producida) AS total_producido
FROM produccion
GROUP BY id_laboratorio, id_producto;

-- Turnos más productivos
SELECT e.id_jornada, SUM(p.cantidad_producida) AS produccion_total
FROM produccion p
JOIN empleado e ON p.id_empleado = e.id_empleado
GROUP BY e.id_jornada
ORDER BY produccion_total DESC;

-- Tiempo promedio de fabricación por medicamento
SELECT id_producto, AVG(DATEDIFF(fecha_fin, fecha_inicio)) AS promedio_dias
FROM produccion
GROUP BY id_producto;


-- ODS: Recursos Humanos
-- Asistencia por jornada
SELECT e.id_jornada, COUNT(*) AS total_asistencias
FROM asistencia a
JOIN empleado e ON a.id_empleado = e.id_empleado
WHERE a.estado = 'Presente'
GROUP BY e.id_jornada;

-- Turnos con mayor ausentismo
SELECT turno, COUNT(*) AS ausencias
FROM asistencia
WHERE estado = 'Ausente'
GROUP BY turno
ORDER BY ausencias DESC;

-- Historial de gestiones por empleado
SELECT id_empleado, tipo_gestion, COUNT(*) AS total
FROM gestion
GROUP BY id_empleado, tipo_gestion;

-- Empleados con mayor rotación
SELECT id_empleado, COUNT(*) AS gestiones
FROM gestion
WHERE tipo_gestion = 'Baja'
GROUP BY id_empleado
ORDER BY gestiones DESC;

-- ODS: Devoluciones e Inspección
-- Tasa de devolución por proveedor
SELECT id_proveedor, COUNT(*) AS total_devoluciones
FROM devolucion
GROUP BY id_proveedor;

-- Motivos más comunes de devolución
SELECT id_motivo, COUNT(*) AS total
FROM devolucion
GROUP BY id_motivo
ORDER BY total DESC;

-- Empleados inspectores con más rechazos
SELECT id_empleado_inspector, COUNT(*) AS rechazos
FROM devolucion
WHERE resultado = 'Rechazado'
GROUP BY id_empleado_inspector;

-- ODS: Promociones y Marketing
-- Promociones activas
SELECT * FROM promocion
WHERE CURDATE() BETWEEN fecha_inicio AND fecha_fin;

-- Descuento promedio aplicado por producto
SELECT id_producto, AVG(descuento) AS promedio_descuento
FROM detalle_promocion
GROUP BY id_producto;

-- Feedback recibido por promoción (asociación no directa)
SELECT f.id_region, COUNT(*) AS total_feedback
FROM feedback f
GROUP BY f.id_region;

-- ODS: Control de Stock por Sucursal
-- Stock actual por producto y sucursal
SELECT id_sucursal, id_producto, cantidad_actual
FROM stock_sucursal;

-- Productos con sobrestock o desabastecimiento
SELECT id_sucursal, id_producto, cantidad_actual, minimo, maximo
FROM stock_sucursal
WHERE cantidad_actual < minimo OR cantidad_actual > maximo;

-- Movimientos de stock recientes
SELECT *
FROM movimiento_stock
WHERE fecha_movimiento >= DATE_SUB(CURDATE(), INTERVAL 7 DAY);

-- Productos más movidos en tienda
SELECT id_producto, SUM(cantidad) AS total_movimientos
FROM movimiento_stock
GROUP BY id_producto
ORDER BY total_movimientos DESC;

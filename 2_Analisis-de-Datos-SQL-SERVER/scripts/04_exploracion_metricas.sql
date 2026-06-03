/*
=========================================
EXPLORANDO LAS COLUMNAS METRICAS DE LA BD
=========================================

PROPOSITO DEL SCRIPT:
	Ver las principales metricas a tomar para poder ver posibles distribuciones y implicaciones.
*/
USE DataWarehouseAnalytics;
GO

-- Total de importe de ventas 
SELECT 
	SUM(importe_venta) AS ventas_totales
FROM oro.fact_ventas;

-- Cantidad de productos vendidos 
SELECT 
	SUM(cantidad) AS productos_vendidos_total
FROM oro.fact_ventas;

-- Promedio de precio de venta 
SELECT 
	ROUND(AVG(precio),0) AS promedio_precio_venta
FROM oro.fact_ventas;

-- Numero total de Ordenes 
SELECT 
	COUNT(DISTINCT numero_orden) AS ordenes_totales 
FROM oro.fact_ventas;

-- Numero total de productos 
SELECT 
	COUNT(DISTINCT codigo_producto) AS productos_totales
FROM oro.dim_productos;

-- Numero total de clientes 
SELECT 
	COUNT(DISTINCT codigo_cliente) AS clientes_totales
FROM oro.dim_clientes;

-- Numero total de clientes que tienen una orden 
SELECT 
	COUNT(DISTINCT c.cliente_llave) AS clientes_con_ordenes_totales
FROM oro.dim_clientes AS c
INNER JOIN oro.fact_ventas AS v
	ON c.cliente_llave = v.cliente_llave;

-- Reporte de Metricas
SELECT 'Ventas Totales' AS Metrica, CAST(SUM(importe_venta) AS INT) AS Valor FROM oro.fact_ventas 
UNION ALL 
SELECT 'Cantidad Total Productos', SUM(cantidad) AS Valor FROM oro.fact_ventas
UNION ALL 
SELECT 'Precio Promedio', CAST(AVG(precio) AS INT) AS Valor FROM oro.fact_ventas
UNION ALL
SELECT 'Total Nr. Ordenes', COUNT(DISTINCT numero_orden) AS Valor  FROM oro.fact_ventas
UNION ALL 
SELECT 'Total Nr. Productos', COUNT(DISTINCT codigo_producto) AS Valor FROM oro.dim_productos
UNION ALL 
SELECT 'Total Nr. Clientes', COUNT(DISTINCT codigo_cliente) AS clientes_totales FROM oro.dim_clientes
UNION ALL 
SELECT
	'Total Nr. Clientes con Orden',
	COUNT(DISTINCT c.cliente_llave) AS clientes_con_ordenes_totales
FROM oro.dim_clientes AS c
INNER JOIN oro.fact_ventas AS v
	ON c.cliente_llave = v.cliente_llave;

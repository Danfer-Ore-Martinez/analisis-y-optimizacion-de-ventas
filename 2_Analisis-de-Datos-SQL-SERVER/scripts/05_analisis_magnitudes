/*
======================
ANALISIS DE MAGNITUDES
======================
	
PROPOSITO DEL SCRIPT:
	Analizar las magnitudes de cada columna dimension, es decir la distribución que existe entre las categorías
	de las columnas dimension 
*/
USE DataWarehouseAnalytics;
GO
-- Clientes Totales por pais 
SELECT 
	pais,
	COUNT(codigo_cliente) AS cantidad_clientes 
FROM oro.dim_clientes
GROUP BY pais
ORDER BY cantidad_clientes DESC;

-- Clientes totales por genero
SELECT 
	genero,
	COUNT(codigo_cliente) AS cantidad_clientes 
FROM oro.dim_clientes
GROUP BY genero
ORDER BY cantidad_clientes  DESC;

-- Productos totales por categoria
SELECT
	categoria,
	COUNT(codigo_producto) AS cantidad_productos
FROM oro.dim_productos
GROUP BY categoria
ORDER BY cantidad_productos DESC;

-- Costo promedio por categoria 
SELECT
	categoria,
	ROUND(AVG(precio),2) AS precio_promedio
FROM oro.dim_productos
GROUP BY categoria
ORDER BY precio_promedio DESC;

-- Ventas totales por categoria 
SELECT 
	p.categoria,
	SUM(v.importe_venta) AS ventas_totales
FROM oro.fact_ventas AS v 
LEFT JOIN oro.dim_productos AS p
	ON v.producto_llave = p.producto_llave
GROUP BY p.categoria
ORDER BY ventas_totales DESC;

-- Ganancias totales por cliente
SELECT 
	c.cliente_llave,
	c.nombre,
	c.apellido,
	SUM(v.importe_venta) AS ganancias_totales
FROM oro.fact_ventas AS v 
LEFT JOIN oro.dim_clientes AS c
	ON v.cliente_llave = c.cliente_llave
GROUP BY 
	c.cliente_llave,
	c.nombre,
	c.apellido
ORDER BY ganancias_totales DESC;

-- Cantidad de productos vendidos por pais 
SELECT 
	c.pais,
	SUM(v.cantidad) AS ventas_totales
FROM oro.fact_ventas AS v
LEFT JOIN oro.dim_clientes AS c
	ON v.cliente_llave = c.cliente_llave
GROUP BY c.pais
ORDER BY ventas_totales DESC;

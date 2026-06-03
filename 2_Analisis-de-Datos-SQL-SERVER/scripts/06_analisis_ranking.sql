/*
===================
Analisis de Ranking
===================

PROPOSITO DEL SCRIPT:
	Realizar rankings, según productos más vendidos o productos menos vendidos.
	Clientes que más han comprado, clientes con menos ordenes, etc. 

*/
USE DataWarehouseAnalytics;
GO
-- Top 5 productos más vendidos 
SELECT TOP 5 
	p.nombre_producto,
	SUM(v.importe_venta) AS ventas_totales
FROM oro.fact_ventas AS v
LEFT JOIN oro.dim_productos AS p
	ON v.producto_llave = p.producto_llave
GROUP BY p.nombre_producto
ORDER BY ventas_totales DESC;

-- Top 5 productos menos vendidos 
SELECT TOP 5 
	p.nombre_producto,
	SUM(v.importe_venta) AS ventas_totales
FROM oro.fact_ventas AS v
LEFT JOIN oro.dim_productos AS p
	ON v.producto_llave = p.producto_llave
GROUP BY p.nombre_producto
ORDER BY ventas_totales ASC;

-- Top 10 clientes que más han comprado
-- Tambien se podia hacer como las formas anteriores, solo es para demostrar que se utilizar funciones de ventana
SELECT 
	cliente_llave,
	nombre,
	apellido,
	ventas_totales
FROM (
	SELECT 
		c.cliente_llave,
		c.nombre,
		c.apellido,
		SUM(v.importe_venta) AS ventas_totales,
		ROW_NUMBER() OVER (ORDER BY SUM(v.importe_venta) DESC) AS rank_cliente 
	FROM oro.fact_ventas AS v
	LEFT JOIN oro.dim_clientes AS c
		ON v.cliente_llave = c.cliente_llave
	GROUP BY 
		c.cliente_llave,
		c.nombre,
		c.apellido) AS T
WHERE rank_cliente <= 10;

-- Top 3 clientes con menos ordenes 
SELECT TOP 3
	c.cliente_llave,
	c.nombre,
	c.apellido,
	COUNT(DISTINCT c.codigo_cliente) AS cantidad_pedidos
FROM oro.fact_ventas AS v
LEFT JOIN oro.dim_clientes AS c
	ON v.cliente_llave = c.cliente_llave
GROUP BY 
	c.cliente_llave,
	c.nombre,
	c.apellido
ORDER BY cantidad_pedidos ASC;

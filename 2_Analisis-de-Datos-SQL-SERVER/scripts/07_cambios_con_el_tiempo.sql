/*
==============================================================
ANALISIS DEL COMPORTAMIENTO DE LA VENTAS A LO LARGO DEL TIEMPO
==============================================================

PROPOSITO DEL SCRIPT:
	Ver el comportamiento de las ventas a lo largo del tiempo 

*/
USE DataWarehouseAnalytics;
GO
-- Ventas por año 
SELECT 
	YEAR(fecha_orden) AS [año],
	MONTH(fecha_orden) AS mes,
	SUM(importe_venta) AS ventas_totales,
	COUNT(DISTINCT cliente_llave) AS numero_clientes,
	SUM(cantidad) AS total_productos_vendidos
FROM oro.fact_ventas
WHERE fecha_orden IS NOT NULL
GROUP BY YEAR(fecha_orden), MONTH(fecha_orden)
ORDER BY YEAR(fecha_orden), MONTH(fecha_orden) ASC;

-- Ventas por año pero con DATETRUNC()
SELECT 
	DATETRUNC(MONTH, fecha_orden) AS fecha,
	SUM(importe_venta) AS ventas_totales,
	COUNT(DISTINCT cliente_llave) AS numero_clientes,
	SUM(cantidad) AS total_productos_vendidos
FROM oro.fact_ventas
WHERE fecha_orden IS NOT NULL
GROUP BY DATETRUNC(MONTH, fecha_orden)
ORDER BY DATETRUNC(MONTH, fecha_orden) ASC;

-- Ventas por año pero utilizando FORMAT()
SELECT 
	FORMAT(fecha_orden,'yyyy-MMM') AS fecha,
	SUM(importe_venta) AS ventas_totales,
	COUNT(DISTINCT cliente_llave) AS numero_clientes,
	SUM(cantidad) AS total_productos_vendidos
FROM oro.fact_ventas
WHERE fecha_orden IS NOT NULL
GROUP BY FORMAT(fecha_orden,'yyyy-MMM')
ORDER BY FORMAT(fecha_orden,'yyyy-MMM') ASC;

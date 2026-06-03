/*
=====================================
ANALISIS ACUMULATIVO DE LAS GANANCIAS
=====================================

PROPOSITO DEL SCRIPT: 
	Ver la acumulación de las ganancias a lo largo de los años 
*/

USE DataWarehouseAnalytics;
GO
SELECT 
	fecha_orden,
	ventas_totales,
	ROUND(promedio_precio,0) AS promedio_precio,
	SUM(ventas_totales) OVER(ORDER BY fecha_orden) AS ventas_acumuladas,
	ROUND(AVG(promedio_precio) OVER(ORDER BY fecha_orden),0) AS promedio_precio_acomulado
FROM (
	-- Sub consulta encargada de obtener el promedio por año y las ganancias totales por año 
	SELECT 
		DATETRUNC(YEAR,fecha_orden) AS fecha_orden,
		SUM(importe_venta) AS ventas_totales,
		AVG(precio) AS promedio_precio
	FROM oro.fact_ventas
	WHERE fecha_orden IS NOT NULL
	GROUP BY DATETRUNC(YEAR,fecha_orden) 
	) AS TT;

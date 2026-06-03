/*
=====================
ANALISIS PARTE - TODO 
=====================

PROPOSITO DEL SCRIPT:
	Ver que porcentaje del total de ventas representa cada categoría 
*/
USE DataWarehouseAnalytics;
GO 
-- Contribución de cada Categoría al total de ventas 
WITH CTE_contri_categoria AS (
	SELECT 
		p.categoria,
		SUM(v.importe_venta) AS ventas_totales
	FROM oro.fact_ventas AS v
	LEFT JOIN oro.dim_productos AS p
		ON v.producto_llave = p.producto_llave
	GROUP BY p.categoria
	)
SELECT 
	categoria,
	CAST(ventas_totales AS INT) AS ventas,
	CAST(SUM(ventas_totales) OVER() AS INT) AS ventas_totales,
	CONCAT(ROUND(CAST(ventas_totales AS FLOAT)/ (SUM(ventas_totales) OVER())*100,2), '%') AS porcentaje_contribucion
FROM CTE_contri_categoria
ORDER BY ventas DESC; 

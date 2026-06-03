/*
===============================
ANALISIS DEL RENDIMENTO POR AÑO 
===============================

PROPOSITO DEL SCRIPT:
	Analizar el redimiento de las ganancias por año, ello implica, el precio promedio y las ventas acumuladas,
	ver las diferencias con el año pasado 
*/

USE DataWarehouseAnalytics;
GO
-- Análisis del rendimiento comparando las ventas por año
-- con el rendimiento general y el rendimiento del año pasado 
SELECT
	fecha,
	promedio_ventas,
	AVG(promedio_ventas) OVER() proGen,
	promedio_ventas - AVG(promedio_ventas) OVER() AS dif_proAct_proGen,
	promedio_ventas - LAG(promedio_ventas) OVER(ORDER BY fecha)  AS dif_anioAct_anioPas
FROM (
	SELECT
		-- Sub consulta promedio ventas por año 
		DATETRUNC(YEAR,v.fecha_orden) AS fecha,
		CAST(ROUND(AVG(v.importe_venta),0) AS INT) AS promedio_ventas
	FROM oro.fact_ventas AS v
	LEFT JOIN oro.dim_productos AS p
		ON v.producto_llave = p.producto_llave
	WHERE v.fecha_orden IS NOT NULL
	GROUP BY DATETRUNC(YEAR,v.fecha_orden)
) AS t;

-- Análisis del rendimiento de los productos por año comparando las ventas, con el promedio de ventas del producto
-- y el promedio de ventas del mismo producto del año pasado 

SELECT 
	anio,
	nombre_producto,
	ventas_totales_actuales,
	-- Análisis Ventas por año - Promedio Ventas por año 
	AVG(ventas_totales_actuales) OVER(PARTITION BY nombre_producto) AS pro_ventas,
	ventas_totales_actuales - AVG(ventas_totales_actuales) OVER(PARTITION BY nombre_producto) AS dif_venAct_proVen,
	CASE 
		WHEN ventas_totales_actuales - AVG(ventas_totales_actuales) OVER(PARTITION BY nombre_producto) > 0 THEN 'Mayor al Promedio'
		WHEN ventas_totales_actuales - AVG(ventas_totales_actuales) OVER(PARTITION BY nombre_producto) < 0 THEN 'Menor al Promedio'
		ELSE 'Igual al Promedio'
	END AS re_dif_venAct_proVen,
	-- Análisis año a año de las ventas 
	LAG(ventas_totales_actuales) OVER(PARTITION BY nombre_producto ORDER BY nombre_producto,anio) AS ani_pas_ventas,
	ventas_totales_actuales - LAG(ventas_totales_actuales) OVER(PARTITION BY nombre_producto ORDER BY anio ) AS dif_ven_aniAct_anioPas,
	CASE 
		WHEN ventas_totales_actuales - LAG(ventas_totales_actuales) OVER(PARTITION BY nombre_producto ORDER BY anio ) > 0 THEN 'Aumenta'
		WHEN ventas_totales_actuales - LAG(ventas_totales_actuales) OVER(PARTITION BY nombre_producto ORDER BY anio ) < 0 THEN 'Disminuye'
		ELSE 'No Cambia'
	END AS re_dif_ven_aniAct_anioPas
FROM ( 
	-- Sub Consulta: Ventas totales de cada producto por año 
	SELECT 
		YEAR(v.fecha_orden) AS anio,
		p.nombre_producto,
		CAST(SUM(v.importe_venta) AS INT) AS ventas_totales_actuales
	FROM oro.fact_ventas AS v
	LEFT JOIN oro.dim_productos AS p
		ON v.producto_llave = p.producto_llave
	WHERE fecha_orden IS NOT NULL
	GROUP BY YEAR(fecha_orden),p.nombre_producto
	) AS t
ORDER BY nombre_producto,anio;

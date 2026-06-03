/*
====================
REPORTE DE PRODUCTOS
====================

Proposito:
	Brindar información relevante sobre los productos, metricas clave y comportamientos 

Objetivos:
	1. Brindar información relevante como nombre, categoria, subcategoria y costos
	2. Agrupar a los productos en categorías según el rendimiento (ALTO, MEDIO,BAJO)
	3. Agregar metricas clave:
		- Ordenes totales
		- Ventas totales
		- Cantidad de total de objetos vendidos
		- Clientes unicos totales
		- Fecha ultimo pedido
		- Tiempo de actividad (meses)
	4. Calcular KPIs:
		- Tiempo transcurrido desde la última orden 
		- Precio promedio de orden
		- Ventas mensuales promedio 
*/
USE DataWarehouseAnalytics;

IF OBJECT_ID('oro.report_productos','V') IS NOT NULL
	DROP VIEW oro.report_productos;
GO
	
CREATE VIEW oro.report_productos AS 
WITH CTE_info_base AS (
	/*------------------------------------------------
	1) CTE PRINCIPAL: INFORMACION RELEVANTE A UTILIZAR
	------------------------------------------------*/
	SELECT 
		p.producto_llave,
		p.codigo_producto,
		p.nombre_producto,
		p.categoria,
		p.sub_categoria,
		CAST(p.precio AS INT) AS precio_producto,
		v.numero_orden,
		CAST(v.importe_venta AS INT) AS importe_venta,
		v.fecha_orden,
		v.cliente_llave,
		v.cantidad
	FROM oro.fact_ventas AS v
	LEFT JOIN oro.dim_productos AS p 
		ON v.producto_llave = p.producto_llave
	WHERE v.fecha_orden IS NOT NULL
), CTE_metricas_productos AS (
	/*-----------------------------------------------------------
	2) CTE METRICAS: Calcular metricas claves sobre los productos 
	-----------------------------------------------------------*/
	SELECT 
		producto_llave,
		codigo_producto,
		nombre_producto,
		categoria,
		sub_categoria,
		precio_producto,
		COUNT(DISTINCT numero_orden) AS ordenes_totales, 
		SUM(importe_venta) AS ventas_totales,
		SUM(cantidad) AS nr_productos_vendidos, 
		COUNT(DISTINCT cliente_llave) AS clientes_totales, 
		MAX(fecha_orden) AS fecha_ultimo_pedido, 
		DATEDIFF(MONTH,MIN(fecha_orden), MAX(fecha_orden)) AS tiempo_activo_meses ,
		ROUND(AVG(CAST(importe_venta AS FLOAT) / NULLIF(cantidad,0)),1) AS promedio_precio_venta
	FROM CTE_info_base
	GROUP BY producto_llave,
			 codigo_producto,
			 nombre_producto,
			 categoria,
			 sub_categoria,
			 precio_producto
)
/*---------------------------------------------------------------------
3) CTE SEGMENTACION: Calcular KPIs claves y agrupar por rango de ventas
---------------------------------------------------------------------*/
SELECT 
	producto_llave,
	codigo_producto,
	nombre_producto,
	categoria,
	sub_categoria,
	precio_producto,
	ordenes_totales,
	-- KPI: Precio promedio de orden 
	CASE 
		WHEN ventas_totales = 0 THEN 0  
		ELSE ventas_totales/ordenes_totales
	END precio_promedio_orden,
	ventas_totales,
	promedio_precio_venta,
	-- Categoría rendimiento por ventas
	CASE 
		WHEN ventas_totales > 50000 THEN 'ALTO'
		WHEN ventas_totales >= 10000 THEN 'MEDIO'
		ELSE 'BAJO'
	END AS rendimiento,
	nr_productos_vendidos,
	clientes_totales,
	fecha_ultimo_pedido,
	-- KPI: Tiempo transcurrido desde la ultima orden 
	DATEDIFF(MONTH,fecha_ultimo_pedido, GETDATE()) AS tiempo_desde_ultima_orden,
	tiempo_activo_meses,
	-- KPI: Promedio ventas mensuales
	CASE 
		WHEN tiempo_activo_meses = 0 THEN ventas_totales 
		ELSE ventas_totales/tiempo_activo_meses
	END promedio_ventas_mensuales
FROM CTE_metricas_productos;

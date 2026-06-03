/*
===================
REPORTE DEL CLIENTE
===================

Advertencia:
	Si existe un VIEW con el nombre 'oro.report_cliente' este se borrara y creara uno nuevo, PRECAUCION AL EJECUTAR
Proposito:
	Brindar información relevante sobre los clientes, metricas clave y comportamientos 

Objetivos:
	1. Brindar información importante como nombres, edad y detalles de transacciones.
	2. Agrupar a los clientes en categorías (VIP,REGULAR,NUEVO) y rangos de edad.
	3. Agregar metricas clave:
		- Ordenes totales
		- Ventas totales
		- Cantidad de total de objetos comprados
		- Productos totales (unicos)
		- Fecha ultimo pedido
		- Tiempo de actividad (meses)
	4. Calcular KPIs:
		- Tiempo transcurrido desde la última orden 
		- Precio promedio de orden
		- Gasto mensual promedio
*/
USE DataWarehouseAnalytics; 

IF OBJECT_ID('oro.report_cliente','V') IS NOT NULL 
	DROP VIEW oro.report_cliente;
GO
CREATE VIEW oro.report_cliente AS 
	WITH CTE_base AS (
		/*----------------------------------------------
		1) CTE PRINCIPAL: INFORMACION RELEVANTE DE LA BD
		----------------------------------------------*/
		SELECT 		
			v.numero_orden,
			v.producto_llave,
			v.fecha_orden,
			CAST(v.precio AS INT) AS precio,
			v.cantidad,
			CAST(v.importe_venta AS INT) AS importe_venta,
			c.cliente_llave,
			c.codigo_cliente,
			CONCAT(c.nombre,' ', c.apellido) AS nombre_cliente,
			DATEDIFF(YEAR,c.fecha_nacimiento, GETDATE()) AS edad
		FROM oro.fact_ventas AS v
		LEFT JOIN oro.dim_clientes AS c
			ON v.cliente_llave = c.cliente_llave
		WHERE v.fecha_orden IS NOT NULL
	), CTE_metricas_cliente AS (
		/*-----------------------------------------
		2) CTE METRICAS: METRICAS CLAVE DEL CLIENTE
		-----------------------------------------*/
		SELECT
			cliente_llave,
			codigo_cliente,
			nombre_cliente,
			edad,
			COUNT(DISTINCT numero_orden) AS ordenes_totales,
			SUM(importe_venta) AS ventas_totales,
			SUM(cantidad) AS nr_productos_comprados,
			COUNT(DISTINCT producto_llave) AS total_productos_diferentes,
			MAX(fecha_orden) AS ultima_orden,
			DATEDIFF(MONTH, MIN(fecha_orden), MAX(fecha_orden)) AS tiempo_activo 
		FROM CTE_base
		GROUP BY  cliente_llave,
				  codigo_cliente, 
				  nombre_cliente, 
				  edad
	)
	/*-------------------------------------------------------------------------------------------------
	3) CTE SEGMENTACION: Segmentar los cliente en rangos de edad o categorías y añadir KPIs importantes
	-------------------------------------------------------------------------------------------------*/
	SELECT 
		cliente_llave,
		codigo_cliente,
		nombre_cliente,
		edad,
		-- Categorías por rangos de edad 
		CASE 
			WHEN edad > 60 THEN '>60'
			WHEN edad BETWEEN 50 AND 60 THEN '50-60'
			WHEN edad BETWEEN 40 AND 49 THEN '40-49'
			WHEN edad BETWEEN 30 AND 39 THEN '30-39'
			WHEN edad BETWEEN 20 AND 29 THEN '20-29'
			ELSE '<20'
		END AS rango_edad,
		-- Categorias por dinero gastado y tiempo de actividad 
		CASE 
			WHEN ventas_totales >= 5000 AND tiempo_activo >= 12 THEN 'VIP'
			WHEN ventas_totales < 5000 AND tiempo_activo >= 12 THEN 'REGULAR'
			ELSE 'NUEVO'
		END AS categoria_cliente,
		ordenes_totales,
		ventas_totales,
		nr_productos_comprados,
		total_productos_diferentes,
		ultima_orden,
		-- KPI tiempo transcurrido en meses desde la última orden realizada
		DATEDIFF(MONTH, ultima_orden, GETDATE())AS tiempo_meses_ultima_orden, 
		tiempo_activo,
		-- KPI: Costo promedio por orden 
		CASE 
			WHEN ventas_totales = 0 THEN 0
			ELSE ventas_totales/ordenes_totales
		END AS precio_promedio_orden,
		-- KPI: Gasto promedio mensual 
		CASE 
			WHEN tiempo_activo = 0 THEN ventas_totales
			ELSE ventas_totales / tiempo_activo
		END AS promedio_gasto_mensual
	FROM CTE_metricas_cliente
GO;

/*
==============================
SEGMENTACIÓN DE LA INFORMACIÓN
==============================

PROPOSITO DEL SCRIPT:
	Agrupar los productos en por rangos de costos, agrupar los clientes por rango de dinero gastado y tiempo de actividad. 
*/

-- Agrupando los productos en rangos de costos
USE DataWarehouseAnalytics;
GO 

WITH CTE_informacion_ventas AS (
	SELECT 
		nombre_producto,
		precio,
		CASE 
			WHEN precio < 100 THEN 'Menor a 100'
			WHEN precio BETWEEN 100 AND 500 THEN '100-500'
			WHEN precio BETWEEN 500 AND 1000 THEN '500-1000'
			ELSE 'Mayor a 1000' 
		END AS rango_costo
	FROM oro.dim_productos
)
SELECT 
	rango_costo,
	COUNT(rango_costo) AS cantidad_productos
FROM CTE_informacion_ventas
GROUP BY rango_costo
ORDER BY cantidad_productos DESC;

/*Agrupación de los clientes 
- VIP: Al menos 12 meses de actividad y 5000 o más de 5000 en compras 
- REGULAR: Al menos 12 meses de actividad y menos de 5000 en compras 
- NUEVO: Menos de 12 meses de actividad
*/

WITH CTE_info_cli_impor_fecha AS (
	-- Selección info cliente, importe total y tiempo activo de cada cliente 
	SELECT
		c.cliente_llave,
		c.nombre,
		c.apellido,
		CAST(SUM(importe_venta) AS INT) AS monto_compra,
		DATEDIFF(MONTH,MIN(v.fecha_orden),MAX(v.fecha_orden)) AS tiempo_activo
	FROM oro.fact_ventas AS v
	LEFT JOIN oro.dim_clientes AS c
		ON v.cliente_llave = c.cliente_llave
	GROUP BY c.cliente_llave,c.nombre, c.apellido
), CTE_categoria_clientes AS (
	-- Agrupación en categorías según los requerimientos establecidos 
	SELECT 
		cliente_llave,
		nombre,
		apellido,
		monto_compra,
		CASE 
			WHEN monto_compra >= 5000 AND tiempo_activo >= 12 THEN 'VIP'
			WHEN monto_compra < 5000 AND tiempo_activo >= 12 THEN 'REGULAR'
			ELSE 'NUEVO'
		END AS categoria_cliente 
	FROM CTE_info_cli_impor_fecha
)
SELECT 
	categoria_cliente,
	COUNT(categoria_cliente) AS cantidad_clientes 
FROM CTE_categoria_clientes
GROUP BY categoria_cliente
ORDER BY cantidad_clientes DESC;

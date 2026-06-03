/*
==================================
EXPLORANDO LOS RANGO DE LAS FECHAS 
==================================

PROPOSITO DEL SCRIPT:
	Entender la distribución de las fechas en las diversas tablas, ver fechas minimas, maximas y la diferencias
	que existen entre ellas. 
*/
USE DataWarehouseAnalytics;
GO
/*---------------------------------
EXPLORANDO FECHAS 'oro.dim_cliente'
---------------------------------*/
-- Exploración de creación de registro de cliente 
SELECT
	MIN(fecha_creacion) AS primer_cliente,
	MAX(fecha_creacion) AS ultimo_cliente,
	DATEDIFF(YEAR,MIN(fecha_creacion),MAX(fecha_creacion)) AS rango_creacion_anios
FROM oro.dim_clientes

-- Explorando las edades de los clientes 
SELECT
	MIN(fecha_nacimiento) AS cliente_mas_antiguo,
	MAX(fecha_nacimiento) AS cliente_mas_joven,
	DATEDIFF(YEAR,MIN(fecha_nacimiento),MAX(fecha_nacimiento)) AS rango_edad_clientes
FROM oro.dim_clientes

/*-----------------------------------
EXPLORANDO FECHAS 'oro.dim_productos'
-----------------------------------*/
-- Explorando fechas de inicio de ventas de productos 
SELECT 
	MIN(fecha_inicio) AS producto_mas_antiguo,
	MAX(fecha_inicio) AS producto_mas_reciente,
	DATEDIFF(YEAR,MIN(fecha_inicio),MAX(fecha_inicio)) AS rango_publicacion_anios
FROM oro.dim_productos

/*---------------------------------
EXPLORANDO FECHAS 'oro.fact_ventas'
---------------------------------*/
SELECT * FROM oro.fact_ventas
-- Explorando las fechas de las ordenes 
SELECT 
	MIN(fecha_orden) AS orden_mas_antigua,
	MAX(fecha_orden) AS orden_mas_reciente, 
	DATEDIFF(YEAR,MIN(fecha_orden),MAX(fecha_orden)) AS rango_ordenes_anios
FROM oro.fact_ventas

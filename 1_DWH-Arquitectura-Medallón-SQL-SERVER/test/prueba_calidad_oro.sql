/*
========================================================
VERIFICACIÓN DE LA CALIDAD DE INFORMACION EN LA CAPA ORO
========================================================

Proposito del Script:
	Revisar la calidad del view en la capa oro, solo se revizaran columnas puntuales para verificar que todo 
	este correcto.
*/
USE DataWareHouse;
GO

/*========================================
VERIFICACION DE CALIDAD "oro.dim_clientes"
========================================*/
SELECT TOP 100 * FROM oro.dim_clientes
-- Verificando que no existan id duplicados 
-- Resultados Esperados: Tabla vacía
SELECT 
	cliente_id,
	COUNT(*)
FROM oro.dim_clientes
GROUP BY cliente_id
HAVING COUNT(*) > 1 

-- Verificando la estandarización del genero 
-- Resultados Esperados: Masculino, Femenino, n/a
SELECT DISTINCT
	genero
FROM oro.dim_clientes

/*=========================================
VERIFICACION DE CALIDAD "oro.dim_productos"
=========================================*/
-- Verificando que no existan id duplicados 
-- Resultados Esperados: Tabla vacía
SELECT 
	producto_id,
	COUNT(*)
FROM oro.dim_productos
GROUP BY producto_id 
HAVING COUNT(*) > 1

/*=========================================
VERIFICACION DE CALIDAD "oro.fact_ventas"
=========================================*/
-- Verificando la integridad de los join 
-- Resultados Esperados: Tabla vacía
SELECT 
	*
FROM oro.fact_ventas AS v
LEFT JOIN oro.dim_clientes AS c
	ON v.cliente_llave = c.cliente_llave
LEFT JOIN oro.dim_productos AS p
	ON v.producto_llave = p.producto_llave
WHERE c.cliente_llave IS NULL OR p.producto_llave IS NULL

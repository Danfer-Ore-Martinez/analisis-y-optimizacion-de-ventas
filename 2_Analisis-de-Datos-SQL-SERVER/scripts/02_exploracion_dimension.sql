/*
==========================================
EXPLORANDO LAS COLUMNAS DIMENSION DE LA BD
==========================================

PROPOSITO DEL SCRIPT:
	Analizar las diversas columnas DIMENSION que existen en las bd con el propósito de entender su distribución,
	así çomo las posibles formas en las que podemos agrupar la información
*/
USE DataWarehouseAnalytics;
GO
/*======================================================
EXPLORANDO LAS COLUMNAS DIMENSION DE 'oro.dim_clientes'
======================================================*/
SELECT TOP 100 * FROM oro.dim_clientes;

-- Pais 
SELECT DISTINCT
	pais
FROM oro.dim_clientes;

-- Estado civil 
SELECT DISTINCT
	estado_civil
FROM oro.dim_clientes;

-- Genero 
SELECT DISTINCT
	genero
FROM oro.dim_clientes;

/*======================================================
EXPLORANDO LAS COLUMNAS DIMENSION DE 'oro.dim_productos'
======================================================*/
SELECT TOP 100 * FROM oro.dim_productos;

-- Categoria, Sub Categoria y Nombre Producto 
SELECT DISTINCT
	categoria,
	sub_categoria,
	nombre_producto
FROM oro.dim_productos
ORDER BY categoria,sub_categoria,nombre_producto;

-- Linea de producto 
SELECT DISTINCT 
	linea_producto
FROM oro.dim_productos;

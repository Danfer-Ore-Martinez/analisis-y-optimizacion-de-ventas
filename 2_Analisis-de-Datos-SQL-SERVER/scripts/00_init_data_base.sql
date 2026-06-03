/*
==========================================
Creación de la Base de Datos y los Schemas
==========================================
Proposito del Script:
    Este Script verifica y crea una nueva base de datos llamada 'DataWarehouseAnalytics'. 
    Si la base de datos ya existe entonces la borra y la vuelve a crear, adicional a esto crea tablas, schemas y 
	los llena de información
	
ADVERTENCIA:
	Ejecutar este Script Creara y borrar la base de datos llamada 'DataWarehouseAnalytics', tener cuidado y 
	verificar si ya existe una base de datos con el mismo nombre
*/

USE master;
GO

-- Verifica y borra la base de datos 'DataWarehouseAnalytics' en caso de que exista
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouseAnalytics')
BEGIN
    ALTER DATABASE DataWarehouseAnalytics SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouseAnalytics;
END;
GO

-- Crea la base de datos'DataWarehouseAnalytics'
CREATE DATABASE DataWarehouseAnalytics;
GO

USE DataWarehouseAnalytics;
GO

-- Crea los schemas
CREATE SCHEMA oro;
GO

/*================
CREACION DE TABLAS
==================*/
  
CREATE TABLE oro.dim_clientes(
	cliente_llave int ,
	cliente_id int,
	codigo_cliente nvarchar(50),
	nombre nvarchar(50),
	apellido nvarchar(50),
	pais nvarchar(50),
	estado_civil nvarchar(50),
	genero nvarchar(50),
	fecha_nacimiento date,
	fecha_creacion date
);


CREATE TABLE oro.dim_productos(
	producto_llave int,
	producto_id int,
	codigo_producto nvarchar(50),
	nombre_producto nvarchar(50),
	categoria_id nvarchar(50),
	categoria nvarchar(50),
	sub_categoria nvarchar(50),
	mantenimento nvarchar(50),
	precio DECIMAL(10,4),
	linea_producto nvarchar(50),
	fecha_inicio date 
);

CREATE TABLE oro.fact_ventas(
	numero_orden nvarchar(50),
	cliente_llave int,
	producto_llave int,
	fecha_orden date,
	fecha_entrega date,
	fecha_limite date,
	precio DECIMAL(10,4),
	cantidad INT,
	importe_venta DECIMAL(10,4)
);


/*==================================================
INGRESO DE DATOS EN LAS TABLAS CREADAS ANTERIORMENTE
==================================================*/
BULK INSERT oro.dim_clientes
FROM 'D:\Data_Analytics\SQL_server\Curso_SQL_Proyectos\DataWareHouseAnalytic\data_sets\oro.dim_clientes.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	CODEPAGE = '65001',
	TABLOCK
);
GO

TRUNCATE TABLE oro.dim_productos;
GO

BULK INSERT oro.dim_productos
FROM 'D:\Data_Analytics\SQL_server\Curso_SQL_Proyectos\DataWareHouseAnalytic\data_sets\oro.dim_productos.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	CODEPAGE = '65001',
	TABLOCK
);
GO

TRUNCATE TABLE oro.fact_ventas;
GO

BULK INSERT oro.fact_ventas
FROM 'D:\Data_Analytics\SQL_server\Curso_SQL_Proyectos\DataWareHouseAnalytic\data_sets\oro.fact_ventas.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	CODEPAGE = '65001',
	TABLOCK
);
GO

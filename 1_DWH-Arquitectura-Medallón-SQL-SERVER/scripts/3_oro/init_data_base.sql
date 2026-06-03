/*
======================================
CREANDO LA BASE DE DATOS Y LOS SCHEMAS
======================================

ADVERTENCIA:
	Al ejecutar este script, si ya existe una base de datos llamada 'DataWareHouse', la va a borrar de manera permanente
	es decir se perderan todos los datos existentes en esa base de datos. Ejecutar con precaución

Proposito del Script: 
	Este script primero que todo verifica la existencia de una base de datos llamada 'DataWareHouse' si existe la borra y
	la crea nuevamente, si no existe crea una nueva base de datos llamada 'DataWareHouse'. 
	En el siguiete bloque crea los SCHEMAS necesarios para este proyecto 'bronce','plata','oro'. 
	Se crean estos 3 schemas porque utilizaremos la arquitectura de Medallón
*/


USE master;

-- Borrando la base de datos 'DataWareHouse' en caso de que ya exista
IF EXISTS(SELECT 1 FROM SYS.databases WHERE name = 'DataWareHouse')
BEGIN 
	ALTER DATABASE DataWareHouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWareHouse;
END; 
GO

-- Creado la base de datos 'DataWareHouse'
CREATE DATABASE DataWareHouse;
GO

USE DataWareHouse;
GO

-- Creando los Schemas para cada capa del Data WereHouse  
GO
CREATE SCHEMA bronce;
GO
CREATE SCHEMA plata;
GO
CREATE SCHEMA oro;

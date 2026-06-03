/*
====================================================================
STORE PROCEDURE: Cargar datos en la capa bronce (Recursos -> Bronce)
====================================================================

ADVERTENCIA:
	Al ejecutar este STORE PROCEDURE, se van a borrar todos los datos de la tabla correspondiente y se van a llenar con los datos 
	de los archivos indicados. PRECAUCIÓN AL EJECUTAR

Proposito del Script:
	Este Script se encarga de crear un STORE PROCEDURE, que carga con datos procedentes de archivos csv las tablas creadas en la etapa 
	de DDL_bronce. Para ello se utilizan las siguientes técnicas:
		- TRUNCATE TABLE
		- BULK INSERT
	Tambien nos da el tiempo que se demora en cargar de datos cada tabla y el tiempo total en cargar las tablas. 
	 
Parametros:
	Ninguno
	Este STORE PROCEDURE no requiere ningun parametro ni tampoco regresa ningun valor
*/

USE DataWareHouse;
GO

CREATE OR ALTER PROCEDURE bronce.cargar_bronce AS 
BEGIN 
	BEGIN TRY 
		DECLARE @tiempo_inicio DATETIME, @tiempo_final DATETIME, @tiempo_inicio_completo DATETIME, @tiempo_final_completo DATETIME;

		PRINT '================================';
		PRINT 'CARGANDO DATOS EN LA CAPA BRONCE';
		PRINT '================================';
		
		PRINT '--------------------------------';
		PRINT 'CARGANDO DATOS EN LAS TABLAS CRM';
		PRINT '--------------------------------';
		
		SET @tiempo_inicio_completo = GETDATE();

		SET @tiempo_inicio = GETDATE();
		PRINT '>>>> Truncando la tabla: bronce.crm_cust_info ';
		TRUNCATE TABLE bronce.crm_cust_info;
		PRINT '>>>> Insertando datos en la tabla: bronce.crm_cust_info ';
		BULK INSERT bronce.crm_cust_info 
		FROM 'D:\Data_Analytics\SQL_server\Curso_SQL_Proyectos\DataWareHouse\datasets\source_crm\cust_info.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @tiempo_final = GETDATE();
		PRINT 'Tiempo de carga de datos: ' + CAST(DATEDIFF(SECOND,@tiempo_inicio,@tiempo_final) AS NVARCHAR) +' Segundos'; 
		PRINT '----------------------------------------------------------------------------------------------';

		SET @tiempo_inicio = GETDATE();
		PRINT '>>>> Truncando la tabla: bronce.crm_prd_info';
		TRUNCATE TABLE bronce.crm_prd_info ;
		PRINT '>>>> Insertando datos en la tabla: bronce.crm_prd_info';
		BULK INSERT bronce.crm_prd_info 
		FROM 'D:\Data_Analytics\SQL_server\Curso_SQL_Proyectos\DataWareHouse\datasets\source_crm\prd_info.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @tiempo_final = GETDATE();
		PRINT 'Tiempo de carga de datos: ' + CAST(DATEDIFF(SECOND,@tiempo_inicio,@tiempo_final) AS NVARCHAR)+' Segundos'; 
		PRINT '----------------------------------------------------------------------------------------------';

		SET @tiempo_inicio = GETDATE();
		PRINT '>>>> Truncando la tabla: bronce.crm_sales_details ';
		TRUNCATE TABLE bronce.crm_sales_details;
		PRINT '>>>> Insertando datos en la tabla:  bronce.crm_sales_details ';
		BULK INSERT bronce.crm_sales_details 
		FROM 'D:\Data_Analytics\SQL_server\Curso_SQL_Proyectos\DataWareHouse\datasets\source_crm\sales_details.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @tiempo_final = GETDATE();
		PRINT 'Tiempo de carga de datos: ' + CAST(DATEDIFF(SECOND,@tiempo_inicio,@tiempo_final) AS NVARCHAR)+' Segundos'; 

		PRINT '--------------------------------';
		PRINT 'CARGANDO DATOS EN LAS TABLAS ERP';
		PRINT '--------------------------------';

		SET @tiempo_inicio = GETDATE();
		PRINT '>>>> Truncando la tabla: bronce.erp_cust_az12 ';
		TRUNCATE TABLE bronce.erp_cust_az12;
		PRINT '>>>> Insertando datos en la tabla:  bronce.erp_cust_az12 ';
		BULK INSERT bronce.erp_cust_az12
		FROM 'D:\Data_Analytics\SQL_server\Curso_SQL_Proyectos\DataWareHouse\datasets\source_erp\CUST_AZ12.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @tiempo_final = GETDATE();
		PRINT 'Tiempo de carga de datos: ' + CAST(DATEDIFF(SECOND,@tiempo_inicio,@tiempo_final) AS NVARCHAR)+' Segundos'; 
		PRINT '----------------------------------------------------------------------------------------------';

		SET @tiempo_inicio = GETDATE();
		PRINT '>>>> Truncando la tabla: bronce.erp_loc_a101 ';
		TRUNCATE TABLE bronce.erp_loc_a101;
		PRINT '>>>> Insertando datos en la tabla:  bronce.erp_loc_a101 ';
		BULK INSERT bronce.erp_loc_a101
		FROM 'D:\Data_Analytics\SQL_server\Curso_SQL_Proyectos\DataWareHouse\datasets\source_erp\LOC_A101.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @tiempo_final = GETDATE();
		PRINT 'Tiempo de carga de datos: ' + CAST(DATEDIFF(SECOND,@tiempo_inicio,@tiempo_final) AS NVARCHAR)+' Segundos'; 
		PRINT '----------------------------------------------------------------------------------------------';

		SET @tiempo_inicio = GETDATE();
		PRINT '>>>> Truncando la tabla: bronce.erp_px_cat_g1v2 ';
		TRUNCATE TABLE bronce.erp_px_cat_g1v2;
		PRINT '>>>> Insertando datos en la tabla: bronce.erp_px_cat_g1v2 ';
		BULK INSERT bronce.erp_px_cat_g1v2
		FROM 'D:\Data_Analytics\SQL_server\Curso_SQL_Proyectos\DataWareHouse\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @tiempo_final = GETDATE();
		PRINT 'Tiempo de carga de datos: ' + CAST(DATEDIFF(SECOND,@tiempo_inicio,@tiempo_final) AS NVARCHAR)+' Segundos';
		PRINT '----------------------------------------------------------------------------------------------';
		
		SET @tiempo_final_completo = GETDATE();
		PRINT '=====================================================';
		PRINT 'PROCESO DE CARGA DE DATOS EN LA CAPA BRONCE TERMINADO';
		PRINT 'Tiempo en cargar todos los datos en la capa bronce: ' + CAST(DATEDIFF(SECOND,@tiempo_inicio_completo,@tiempo_final_completo) AS NVARCHAR) + ' Segundos';
		PRINT '=====================================================';
	END TRY 
	BEGIN CATCH 
		PRINT '=================================================================';
		PRINT ('A OCURRIDO UN ERROR DURANTE LA CARGA DE DATOS EN LA CAPA BRONCE');
		PRINT ('Mensaje de Error: ' + ERROR_MESSAGE());
		PRINT ('Número de Error: ' + CAST(ERROR_NUMBER() AS NVARCHAR));
		PRINT ('Linea del Error: ' + CAST(ERROR_LINE() AS NVARCHAR));
		PRINT ('Pocedimiento del Error: ' + ERROR_PROCEDURE());
		PRINT '=================================================================';
	END CATCH 
END;
GO

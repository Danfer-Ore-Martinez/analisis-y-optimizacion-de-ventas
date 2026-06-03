/*
===================================================================================
STORE PROCEDURE: Cargar datos en la capa plata (Bronce -(Limpeza de datos)-> Plata)
===================================================================================

ADVERTENCIA:
	Al ejecutar este STORE PROCEDURE, se van a borrar todos los datos de la tabla correspondiente y se van a llenar con los datos 
	de los archivos indicados. PRECAUCIÓN AL EJECUTAR

Proposito del Script:
	Este Script se encarga de crear un STORE PROCEDURE, para insertar los datos de la tabla bronce previamente 
	se realiza una limpieza y estandarización de los datos, para ello se utilizan siguientes técnicas:
		- Batch Processing
		- Full Load 
		- Truncate & Insert
Parametros:
	Ninguno
	Este STORE PROCEDURE no requiere ningun parametro ni tampoco regresa ningun valor
*/
USE DataWareHouse;
GO
CREATE OR ALTER PROCEDURE plata.cargar_plata AS 
BEGIN 
	BEGIN TRY
		DECLARE @tiempo_inicio DATETIME, @tiempo_final DATETIME, @tiempo_inicio_completo DATETIME, @tiempo_final_completo DATETIME;
		PRINT '================================';
		PRINT 'CARGANDO DATOS EN LA CAPA PLATA';
		PRINT '================================';
		
		PRINT '--------------------------------';
		PRINT 'CARGANDO DATOS EN LAS TABLAS CRM';
		PRINT '--------------------------------';

		SET @tiempo_inicio_completo = GETDATE();

		SET @tiempo_inicio = GETDATE();
		PRINT '>>>> Truncando la tabla: plata.crm_cust_info ';
		TRUNCATE TABLE plata.crm_cust_info;
		PRINT '>>>> Insertando datos en la tabla: plata.crm_cust_info ';
		INSERT INTO plata.crm_cust_info(
				cst_id,
				cst_key,
				cst_firstname,
				cst_lastname,
				cst_marital_status,
				cst_gndr,
				cst_create_date)
		SELECT 
			cst_id,
			cst_key,
			TRIM(cst_firstname)AS cst_firstname, -- Eliminando espacios innecesarios 
			TRIM(cst_lastname) AS cst_lastname,  -- Eliminando espacios innecesarios 
			CASE UPPER(TRIM(cst_marital_status)) 
				WHEN 'S' THEN 'Soltero'
				WHEN 'M' THEN 'Casado'
				ELSE 'n/a'
			END cst_marital_status, -- Estandarizando y normalizando valores
			CASE UPPER(TRIM(cst_gndr))
				WHEN 'F' THEN 'Femenino'
				WHEN 'M' THEN 'Masculino'
				ELSE 'n/a'
			END AS cst_gndr, -- Estandarizando y normalizando valores
			cst_create_date
		FROM 
			(SELECT 
				*,
				ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS registro_mas_reciente
				FROM bronce.crm_cust_info
				WHERE cst_id IS NOT NULL) T 
		WHERE registro_mas_reciente = 1 -- Seleccionamos solo el registro más reciente con la información del cliente
		SET @tiempo_final = GETDATE();
		PRINT 'Tiempo de carga de datos: ' + CAST(DATEDIFF(SECOND,@tiempo_inicio,@tiempo_final) AS NVARCHAR) +' Segundos'; 
		PRINT '----------------------------------------------------------------------------------------------';
		
		SET @tiempo_inicio = GETDATE();
		PRINT '>>>> Truncando la tabla: plata.crm_prd_info';
		TRUNCATE TABLE plata.crm_prd_info;
		PRINT '>>>> Insertando datos en la tabla: plata.crm_prd_info';
		INSERT INTO plata.crm_prd_info(
			prd_id,
			cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt)
		SELECT 
			prd_id,
			-- Separa las columna llamada prd_key en dos componentes, para una mejor busqueda y relación lógica
			REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id, 
			SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key, 
			---------------------------------------------------------------------------------------------------
			prd_nm, 
			ISNULL(prd_cost,0) AS prd_cost,
			CASE  UPPER(TRIM(prd_line))
				WHEN 'M' THEN 'Montaña'
				WHEN 'R' THEN 'Camino'
				WHEN 'S' THEN 'Otras Ventas'
				WHEN 'T' THEN 'Turismo'
				ELSE 'n/a'
			END AS prd_line, -- Normalizando y estandarizando datos
			-- Arreglando errores en lógicos en las fechas (fecha de fin menor a fecha de inicio)
			prd_start_dt,
			DATEADD(DAY,-1,LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt ASC)) AS prd_end_dt 
		FROM bronce.crm_prd_info
		SET @tiempo_final = GETDATE();
		PRINT 'Tiempo de carga de datos: ' + CAST(DATEDIFF(SECOND,@tiempo_inicio,@tiempo_final) AS NVARCHAR)+' Segundos'; 
		PRINT '----------------------------------------------------------------------------------------------';

		SET @tiempo_inicio = GETDATE();
		PRINT '>>>> Truncando la tabla: plata.crm_sales_details ';
		TRUNCATE TABLE plata.crm_sales_details;
		PRINT '>>>> Insertando datos en la tabla:  plata.crm_sales_details ';
		INSERT INTO plata.crm_sales_details(
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price
			)
		SELECT 
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			-- Cambiar el tipo de dato en plata.crm_sales_details son INT ahora serán DATE, en caso de ser fechas incorrectas serán NULL
			CASE
				WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL 
				ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
			END AS sls_order_dt,
			CASE
				WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL 
				ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
			END AS sls_ship_dt,
			CASE
				WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL 
				ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
			END AS sls_due_dt,
			/* Logica/Reglas a seguir 
			- Si las ventas son negativas, cero, NULL o no conciden con el calculo, entonces se remplaza usando la cantidad * ABS(precio)
			- Si el precio negativo, cero o NULL, entonces se remplaza usando ABS(ventas)/cantidad
			*/
			CASE 
				WHEN sls_sales IS NULL OR sls_sales != sls_quantity*ABS(sls_price) OR sls_sales <=0 
					THEN CAST(sls_quantity*ABS(sls_price) AS DECIMAL(10,4))
				ELSE CAST(sls_sales AS DECIMAL(10,4))
			END AS sls_sales,
			sls_quantity,
			CASE 
				WHEN sls_price IS NULL OR sls_price <=0 
					THEN CAST(ROUND(sls_sales/NULLIF(sls_quantity,0),4) AS DECIMAL(10,4))
				ELSE CAST(sls_price AS DECIMAL(10,4))
			END sls_price
		FROM bronce.crm_sales_details
		SET @tiempo_final = GETDATE();
		PRINT 'Tiempo de carga de datos: ' + CAST(DATEDIFF(SECOND,@tiempo_inicio,@tiempo_final) AS NVARCHAR)+' Segundos'; 

		PRINT '--------------------------------';
		PRINT 'CARGANDO DATOS EN LAS TABLAS ERP';
		PRINT '--------------------------------';

		SET @tiempo_inicio = GETDATE();
		PRINT '>>>> Truncando la tabla: plata.erp_cust_az12 ';
		TRUNCATE TABLE plata.erp_cust_az12;
		PRINT '>>>> Insertando datos en la tabla:  plata.erp_cust_az12 ';
		INSERT INTO plata.erp_cust_az12(
			cid,
			bdate,
			gen
			)
		SELECT 
			CASE
				WHEN cid LIKE 'NAS%'THEN SUBSTRING(cid,4,LEN(cid))
				ELSE cid
			END AS cid, -- Cambiando el codigo al mismo formato de crm_cust_info 
			CASE 
				WHEN bdate > GETDATE() THEN NULL
				ELSE bdate 
			END AS bdate, -- Tranformando en NULL las fechas imposibles (Fechas futuras)
			CASE 
				WHEN TRIM(UPPER(gen)) IN ('F', 'FEMALE') THEN 'Femenino'
				WHEN TRIM(UPPER(gen)) IN ('M', 'MALE') THEN 'Masculino'
				ELSE 'n/a' 
			END gen -- Estandarizando datos de genero 
		FROM bronce.erp_cust_az12;
		SET @tiempo_final = GETDATE();
		PRINT 'Tiempo de carga de datos: ' + CAST(DATEDIFF(SECOND,@tiempo_inicio,@tiempo_final) AS NVARCHAR)+' Segundos'; 
		PRINT '----------------------------------------------------------------------------------------------';

		SET @tiempo_inicio = GETDATE();
		PRINT '>>>> Truncando la tabla: plata.erp_loc_a101 ';
		TRUNCATE TABLE plata.erp_loc_a101;
		PRINT '>>>> Insertando datos en la tabla:  plata.erp_loc_a101 ';
		INSERT INTO plata.erp_loc_a101(
			cid,
			cntry
		)
		SELECT 
			REPLACE(cid,'-','') AS cdi,-- Cambiando el codigo al mismo formato de crm_cust_info 
			CASE
				WHEN UPPER(TRIM(cntry)) IN ('US','USA') THEN 'United States'
				WHEN UPPER(TRIM(cntry)) = 'DE' THEN 'Germany'
				WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'	
				ELSE TRIM(cntry)
			END AS cntry -- Estandarizando los valores de los paises a formato de nombre completo 
		FROM bronce.erp_loc_a101;
		SET @tiempo_final = GETDATE();
		PRINT 'Tiempo de carga de datos: ' + CAST(DATEDIFF(SECOND,@tiempo_inicio,@tiempo_final) AS NVARCHAR)+' Segundos'; 
		PRINT '----------------------------------------------------------------------------------------------';

		SET @tiempo_inicio = GETDATE();
		PRINT '>>>> Truncando la tabla: plata.erp_px_cat_g1v2 ';
		TRUNCATE TABLE plata.erp_px_cat_g1v2;
		PRINT '>>>> Insertando datos en la tabla: plata.erp_px_cat_g1v2 ';
		INSERT INTO plata.erp_px_cat_g1v2(
			id,
			cat,
			subcat,
			maintenance
		) -- Calidad de los datos excelente, no se tienen que realizar transformaciones 
		SELECT 
			id,
			cat,
			subcat,
			maintenance 
		FROM bronce.erp_px_cat_g1v2;
		SET @tiempo_final = GETDATE();
		PRINT 'Tiempo de carga de datos: ' + CAST(DATEDIFF(SECOND,@tiempo_inicio,@tiempo_final) AS NVARCHAR)+' Segundos';
		PRINT '----------------------------------------------------------------------------------------------';
		
		SET @tiempo_final_completo = GETDATE();
		PRINT '=====================================================';
		PRINT 'PROCESO DE CARGA DE DATOS EN LA CAPA PLATA TERMINADO';
		PRINT 'Tiempo en cargar todos los datos en la capa plata: ' + CAST(DATEDIFF(SECOND,@tiempo_inicio_completo,@tiempo_final_completo) AS NVARCHAR) + ' Segundos';
		PRINT '=====================================================';
	END TRY 
	BEGIN CATCH
		PRINT '=================================================================';
		PRINT ('A OCURRIDO UN ERROR DURANTE LA CARGA DE DATOS EN LA CAPA PLATA');
		PRINT ('Mensaje de Error: ' + ERROR_MESSAGE());
		PRINT ('Número de Error: ' + CAST(ERROR_NUMBER() AS NVARCHAR));
		PRINT ('Linea del Error: ' + CAST(ERROR_LINE() AS NVARCHAR));
		PRINT ('Pocedimiento del Error: ' + ERROR_PROCEDURE());
		PRINT '=================================================================';
	END CATCH 
END;  
GO

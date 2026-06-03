/*
==========================================================
VERIFICACIÓN DE LA CALIDAD DE INFORMACION EN LA CAPA PLATA 
==========================================================

Proposito del Script:
	Revisar la calidad tabla por tabla columna por columna para vericar que cumpla estándares de calidad en la 
	información, se verifica:
		- Llaves primarias duplicadas. 
    - Valores NULL.
    - Logica de negocio.
    - Valores imposibles como fechas de nacimiento futuras.
    - Espacios en blanco innecesarios.
    - Estandarizacion de la informacion.
*/

USE DataWareHouse;
GO

/*========================================
VERIFICACIÓN CALIDAD "plata.crm_cust_info"
========================================*/
SELECT TOP 100 * FROM plata.crm_cust_info

-- Verificar si existen valores nulos o duplicados en la llave primaria 
-- Resultados esperados: Tabla sin resultados 
SELECT 
	cst_id,
	COUNT(*) AS cantidad_repeticiones
FROM plata.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL 

-- Verificar que no existan espacios no deseados
-- Resultados esperados: Tabla sin resultados 
SELECT 
	cst_firstname
FROM plata.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

SELECT 
	cst_lastname
FROM plata.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname)

SELECT 
	cst_marital_status
FROM plata.crm_cust_info
WHERE cst_marital_status != TRIM(cst_marital_status)

SELECT 
	cst_gndr
FROM plata.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr)

-- Estandarización de los datos y consistencia de la información

-- Resultados Esperados: n/a, Casado, Soltero 
SELECT DISTINCT
	cst_marital_status
FROM plata.crm_cust_info

-- Resultados Esperados: n/a, Femenino, Masculino 
SELECT DISTINCT
	cst_gndr
FROM plata.crm_cust_info

/*========================================
VERIFICACIÓN CALIDAD "plata.crm_prd_info"
========================================*/
SELECT TOP 100 * FROM plata.crm_prd_info

-- Verificar si existen valores nulos o duplicados en la llave primaria 
-- Resultados esperados: Tabla sin resultados 
SELECT 
	prd_id,
	COUNT(*) AS cantidad_repeticiones
FROM plata.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL

-- Verificar que no existan espacios no deseados
-- Resultados esperados: Tabla sin resultados 
SELECT 
	prd_key 
FROM plata.crm_prd_info
WHERE prd_key != TRIM(prd_key)

SELECT 
	prd_nm 
FROM plata.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

-- Verificar si existen valores negativos o nulos en el prd_cost
-- Resultados esperados: Tabla sin resultados 

SELECT
	prd_id,
	prd_cost
FROM plata.crm_prd_info 
WHERE prd_cost < 0 OR prd_cost IS NULL

-- Estandarización de los datos y consistencia de la información
-- Resultados Esperados "M", "R", "S", "T" o "n/a"
SELECT DISTINCT
	prd_line
FROM plata.crm_prd_info

-- Verificar la logica de las fechas 
-- Resultados Esperados: Tabla sin resultados
SELECT
	prd_key,
	prd_start_dt,
	prd_end_dt
FROM plata.crm_prd_info
WHERE prd_end_dt < prd_start_dt

/*============================================
VERIFICACIÓN CALIDAD "plata.crm_sales_details"
============================================*/
SELECT TOP 100 * FROM plata.crm_sales_details
-- Verificar si existen espacios innecesarios 
-- IMPORTANTE: Aquí no se verifica si son datos unicos porque como son detalles de venta pueden
-- pueden existir multiples elementos relacionadas a una misma orden
-- Resultados esperados: Tabla sin resultados 
SELECT 
	sls_ord_num
FROM plata.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num)

-- Verificar que no existan espacios no deseados
-- Resultados esperados: Tabla sin resultados
SELECT 
	sls_prd_key
FROM plata.crm_sales_details
WHERE sls_prd_key != TRIM(sls_prd_key)

-- Verificamos que todas las llaves de los productos se encuentren en la tabla plata.crm_prd_info 
-- Resultados esperados: Tabla sin resultados
SELECT 
	sls_prd_key
FROM plata.crm_sales_details
WHERE sls_prd_key NOT IN(
						SELECT 
							prd_key 
						FROM plata.crm_prd_info
						)

-- Verificar que el sls_cust_id sea valido
-- Resultados esperados: Tabla sin resultados
SELECT 
	sls_cust_id
FROM plata.crm_sales_details
WHERE sls_cust_id NOT IN (
						  SELECT 
							  cst_id
						  FROM plata.crm_cust_info
						  )
-- Verificar si las fechas son validas (fechas extremas(mayor a 2050 o menor a 1900), logica en fechas orde_dt < due_dt y ship_dt)
-- Resultados Esperados: Tabla vacía 

SELECT 
	sls_order_dt
FROM plata.crm_sales_details
WHERE sls_order_dt >= '2050/01/01'
	  OR sls_order_dt  <= '1900/01/01'

SELECT 
	sls_ship_dt
FROM plata.crm_sales_details
WHERE sls_ship_dt >= '2050/01/01'
	  OR sls_ship_dt  <= '1900/01/01'

SELECT 
	sls_due_dt
FROM plata.crm_sales_details
WHERE sls_due_dt >= '2050/01/01'
	  OR sls_due_dt  <= '1900/01/01'

SELECT 
	*
FROM plata.crm_sales_details
WHERE sls_order_dt > sls_due_dt OR sls_order_dt > sls_ship_dt

-- Verificación de la consitencia de la informacion entre: Sales, Quantity, Price
-- Sales = Quantity * Price
-- Ningun valor puede ser NULL, cero o negativo 
-- Resultados Esperados: Tabla vacia
SELECT
	sls_sales,
	sls_price,
	sls_quantity
FROM plata.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price 
	OR sls_quantity IS NULL OR sls_price IS NULL OR sls_sales IS NULL
	OR sls_quantity <= 0 OR sls_price <= 0 OR sls_sales <= 0 
ORDER BY sls_sales,sls_quantity,sls_price

/*=============================================
VERIFICACIÓN CALIDAD "plata.erp_cust_az_12"
=============================================*/
SELECT TOP 100 * FROM plata.erp_cust_az12;
--Vericación no existan ID duplicados
-- Resultados Esperados: Tabla vacia

SELECT 
	CID,
	COUNT(*) AS repeticiones
FROM plata.erp_cust_az12
GROUP BY CID
HAVING CID IS NULL OR COUNT(*) > 1;
--Verificación que no existan espacios innecesarios
-- Resultados Esperados: Tabla vacia

SELECT 
	CID
FROM plata.erp_cust_az12
WHERE CID != TRIM(CID)
-- Verificación que todos los id se encuentren en plata.crm_cust_info
-- Resultados Esperados: Tabla vacia

SELECT 
	cid 
FROM plata.erp_cust_az12
WHERE cid NOT IN(SELECT 
					cst_key
				FROM plata.crm_cust_info
				)
-- Verificación fechas, casos extremos personas  el futuro
-- Como no se puede estar muy seguro de la fecha de nacimiento pasado, dejamos estas fechas 
-- Resultados Esperados: Tabla vacia
SELECT 
	bdate
FROM plata.erp_cust_az12
WHERE bdate <= '1926-01-01' OR bdate >= GETDATE()

-- Estandarización de la información
-- Resultados Esperados: Male,Female,n/a 
SELECT DISTINCT
	gen
FROM plata.erp_cust_az12

/*=============================================
VERIFICACIÓN CALIDAD "plata.erp_loc_a101"
=============================================*/

SELECT * FROM plata.erp_loc_a101
-- Verificación que existan id duplicados 
-- Resultados Esperados: Tabla vacía 
SELECT 
	cid,
	COUNT(*) AS repeticiones 
FROM plata.erp_loc_a101
GROUP BY cid 
having cid IS NULL OR COUNT(*) > 1

-- Verificando que no existan espacios innecesarios 
-- Resultados Esperados: Tabla vacia 
SELECT 
	cid 
FROM plata.erp_loc_a101
WHERE cid != TRIM(cid)

-- Verificando que todas las llaves de usuario estén en el registro de usuarios
-- Resultados Esperados: Tabla vacia
SELECT 
	cid,
	cntry 
FROM plata.erp_loc_a101 
WHERE cid NOT IN (SELECT 
					cst_key
					FROM plata.crm_cust_info)

-- Verificando que no existan espacios duplicados
-- Resultados Esperados: Tabla vacia 
SELECT 
	cntry
FROM plata.erp_loc_a101
WHERE cntry != TRIM(cntry)	
-- Estandarización de datos
-- Resultados Esperados: United States, Germany, Australia, Canada, France, n/a, United Kingdom
SELECT DISTINCT
	cntry
FROM plata.erp_loc_a101

/*=============================================
VERIFICACIÓN CALIDAD "plata.erp_px_cat_g1v2"
=============================================*/
SELECT TOP 100 * FROM plata.erp_px_cat_g1v2

-- Verifiación si todas las id son iguales a las categorias de los productos 
-- información valida
SELECT 
	id
FROM plata.erp_px_cat_g1v2
WHERE id NOT IN (SELECT 
					cat_id
				 FROM plata.crm_prd_info
				)

-- Verificando que no existan espacios vacios 
-- Resultados Esperados: Tabla vacia 
SELECT 
	cat,
	subcat,
	maintenance
FROM plata.erp_px_cat_g1v2
WHERE cat != TRIM(cat) 
	OR subcat != TRIM(subcat) 
	OR maintenance != TRIM(maintenance) 

-- Estandarización de los resultados 
SELECT DISTINCT
	cat
FROM plata.erp_px_cat_g1v2

SELECT DISTINCT
	subcat
FROM plata.erp_px_cat_g1v2

SELECT DISTINCT
	maintenance
FROM plata.erp_px_cat_g1v2

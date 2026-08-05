/*
============================================
DDL Script: Creación de Views en la capa Oro
============================================

ADVERTENCIA:
	Si ya existen viws con los nombre indicados se van a borrar y reemplazar, TENER CUIDADO AL EJECUTAR EL CODIGO

Proposito del script: 
	Este Script verifica si existen Views y los borra en caso de que existan y luego crea los views en la capa oro.
	La capa oro esta representada por un esquema de estrella dividica en tablas DIMENSION y FACT.

	Cada View transforma y combina diferentes tablas de la capa plata (Capa con la información transformada, limpia,
	y ampliada).

USOS:
	Esta capa se utiliza para realizar reportes y analizar la información.
*/

USE DataWareHouse;
GO 

/*======================================
CREACION VIEW DIMENSION oro.dim_clientes
======================================*/
IF OBJECT_ID('oro.dim_clientes','V') IS NOT NULL
	DROP VIEW oro.dim_clientes;
GO
CREATE VIEW oro.dim_clientes AS( 
	SELECT 
		ROW_NUMBER() OVER(ORDER BY ci.cst_id) AS cliente_llave,
		ci.cst_id AS cliente_id,
		ci.cst_key AS codigo_cliente,
		ci.cst_firstname AS nombre,
		ci.cst_lastname AS apellido,
		cloc.cntry AS pais,
		ci.cst_marital_status AS estado_civil,
		CASE 
			WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM_cust_info es la principal fuente de datos en genero
			ELSE ISNULL(caz.gen,'n/a')
		END AS genero,
		caz.bdate AS fecha_nacimiento,
		ci.cst_create_date AS fecha_creacion
	FROM plata.crm_cust_info AS ci
	LEFT JOIN plata.erp_cust_az12 AS caz
		ON caz.cid = ci.cst_key
	LEFT JOIN plata.erp_loc_a101 AS cloc
		ON cloc.cid = ci.cst_key
);
GO
/*=======================================
CREACION VIEW DIMENSION oro.dim_productos 
=======================================*/
IF OBJECT_ID('oro.dim_productos','V') IS NOT NULL
	DROP VIEW oro.dim_productos;
GO 
CREATE VIEW oro.dim_productos AS(
	SELECT 
		ROW_NUMBER() OVER(ORDER BY pin.prd_start_dt, pin.prd_key) AS producto_llave,
		pin.prd_id AS producto_id,
		pin.prd_key AS codigo_producto,
		pin.prd_nm AS nombre_producto,
		pin.cat_id AS categoria_id,
		pc.cat AS categoria,
		pc.subcat AS sub_categoria,
		pc.maintenance AS mantenimento,
		pin.prd_cost AS precio,
		pin.prd_line AS linea_producto,
		pin.prd_start_dt AS fecha_inicio
	FROM plata.crm_prd_info AS pin
	LEFT JOIN plata.erp_px_cat_g1v2 AS pc
		ON pin.cat_id = pc.id
	WHERE pin.prd_end_dt IS NULL -- Filtramos la fecha para obtener solo información sobre productos vigentes
	);
GO

/*================================
CREACION VIEW FACT oro.fact_ventas 
================================*/
IF OBJECT_ID('oro.fact_ventas','V') IS NOT NULL
	DROP VIEW oro.fact_ventas;
GO 
CREATE VIEW oro.fact_ventas AS (
	SELECT
		sd.sls_ord_num AS numero_orden,
		cl.cliente_llave,
		pr.producto_llave, 
		sd.sls_order_dt AS fecha_orden,
		sd.sls_ship_dt AS fecha_entrega,
		sd.sls_due_dt AS fecha_limite,
		sd.sls_price AS precio,
		sd.sls_quantity AS cantidad,
		sd.sls_sales AS importe_venta
	FROM plata.crm_sales_details AS sd
	LEFT JOIN oro.dim_clientes AS cl
		ON sd.sls_cust_id = cl.cliente_id
	LEFT JOIN oro.dim_productos AS pr 
		ON pr.codigo_producto = sd.sls_prd_key
);


USE Datawarehouse;
GO 

/**
 *  CRM is prioritized for customer objects if any data conflict occurs.
 **/

-- Object: Customer 
CREATE VIEW gold.dim_customers AS
	SELECT
		cs1.cst_id               AS customer_id,  -- primary key 
		cs1.cst_key              AS customer_code, 
		cs1.cst_firstname        AS first_name, 
		cs1.cst_lastname         AS last_name, 
		COALESCE(NULLIF(cs1.cst_gndr, 'n/a'), cs2.gen) AS gender,
		cs2.bdate                AS birthday,
		cs1.cst_marital_status   AS marital_status,
		cs1.cst_create_date      AS create_day,
		loc.cntry                AS country
	FROM silver.crm_cust_info cs1 
	FULL JOIN silver.erp_loc_a101 loc ON cs1.cst_key = loc.cid 
	FULL JOIN silver.erp_cust_az12 cs2 ON cs2.cid = cs1.cst_key;

GO 

--Object: Product 
SELECT * 
FROM silver.crm_prd_info prd
FULL JOIN silver.erp_px_cat_g1v2 cat ON TRIM(prd.cat_id) = TRIM(cat.id)


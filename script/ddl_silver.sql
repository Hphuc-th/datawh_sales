-- 
use Datawarehouse
GO
PRINT (' Loading into silver.erp_cust_az12') 
TRUNCATE TABLE silver.erp_cust_az12 
GO
INSERT INTO silver.erp_cust_az12 (cid,bdate,gen)
SELECT 
    CASE 
        WHEN TRIM(cid) LIKE 'NAS%' THEN SUBSTRING(TRIM(cid), 4, LEN(TRIM(cid)))
        ELSE TRIM(cid) 
    END AS cid,
    CAST(bdate AS DATE) AS bdate, 
    CASE 
        WHEN gen IS NULL OR TRIM(gen) = '' THEN 'n/a'
        WHEN UPPER(TRIM(gen)) = 'F' THEN 'Female'
        WHEN UPPER(TRIM(gen)) = 'M' THEN 'Male'
        ELSE UPPER(TRIM(gen))
    END AS gen
FROM bronze.erp_cust_az12;
GO
TRUNCATE TABLE silver.erp_px_cat_g1v2
INSERT INTO silver.erp_px_cat_g1v2 (id,cat,subcate,maintenance)
SELECT *
FROM bronze.erp_px_cat_g1v2;
GO
TRUNCATE TABLE silver.erp_loc_a101
INSERT INTO silver.erp_loc_a101 (cid,cntry)
SELECT TRIM(REPLACE(cid,'-','')) AS cid, CASE WHEN cntry IS NULL OR TRIM(cntry)='' THEN 'n/a'
				WHEN UPPER(TRIM(cntry)) IN ('US','United Kingdom') THEN 'United States' 
				WHEN UPPER(TRIM(cntry)) IN ('DE', 'Germany') THEN 'Germany'
				ELSE UPPER(TRIM(cntry))
			END AS cntry
FROM bronze.erp_loc_a101;
-- 
TRUNCATE TABLE silver.crm_cust_info
INSERT INTO silver.crm_cust_info (cst_id,cst_key,cst_firstname,cst_lastname,cst_marital_status,cst_gndr,cst_create_date)
SELECT 
    cst_id ,
    TRIM(cst_key) AS cst_key, 
    TRIM(cst_firstname) AS cst_firstname, 
    TRIM(cst_lastname) AS cst_lastname,
    CASE 
        WHEN cst_marital_status IS NULL THEN 'n/a'
        WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married' 
        WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'  
        ELSE 'n/a' 
    END AS cst_marital_status, 
    CASE 
        WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male' 
        WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female' 
        ELSE 'n/a'
    END AS cst_gndr,
    CAST(cst_create_date AS DATE) AS cst_create_date
FROM ( 
    SELECT 
        *,  
        ROW_NUMBER() OVER (
            PARTITION BY cst_id 
            ORDER BY cst_create_date DESC 
        ) AS rn
    FROM bronze.crm_cust_info
    WHERE cst_id IS NOT NULL
) AS sb
WHERE rn = 1;

TRUNCATE TABLE silver.crm_sales_details;
INSERT INTO silver.crm_sales_details (
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
    TRIM(sls_ord_num) AS sls_ord_num, 
    TRIM(sls_prd_key) AS sls_prd_key, 
    sls_cust_id AS sls_cust_id,
    CASE 
				WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
				ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
			END AS sls_order_dt,
			CASE 
				WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
				ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
			END AS sls_ship_dt,
			CASE 
				WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
				ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
			END AS sls_due_dt,
			CASE 
				WHEN sls_sales IS NULL OR sls_sales<=0 or sls_sales <> sls_quantity*sls_price THEN sls_quantity*ABS(NULLIF(sls_price,0))
				ELSE sls_sales
			END AS sls_sales,
			sls_quantity,
			CASE 
				WHEN sls_price IS NULL OR sls_price<0 THEN ABS(NULLIF(sls_sales,0))/sls_quantity
				ELSE sls_price
			END AS sls_price
 FROM bronze.crm_sales_details AS sb







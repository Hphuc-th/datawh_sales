USE Datawarehouse;
GO

IF OBJECT_ID('silver.load_silver', 'P') IS NOT NULL
    DROP PROCEDURE silver.load_silver;
GO

CREATE PROCEDURE silver.load_silver
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        DECLARE
            @batch_start_time DATETIME2,
            @batch_end_time   DATETIME2,
            @start_time       DATETIME2,
            @end_time         DATETIME2;

        SET @batch_start_time = SYSDATETIME();

        PRINT '==================================================';
        PRINT ' BATCH PROCESS STARTED AT: ' + CAST(@batch_start_time AS VARCHAR(30));
        PRINT '==================================================';

        SET @start_time = SYSDATETIME();
    PRINT 'Loading data into: silver.erp_cust_az12...';
    
    TRUNCATE TABLE silver.erp_cust_az12; 
    
    INSERT INTO silver.erp_cust_az12 (cid, bdate, gen)
    SELECT 
        CASE 
            WHEN TRIM(cid) LIKE 'NAS%' THEN SUBSTRING(TRIM(cid), 4, LEN(TRIM(cid)))
            ELSE TRIM(cid) 
        END AS cid,
       CASE 
			WHEN CAST(bdate AS DATE) > CAST(GETDATE() AS DATE) THEN NULL
			ELSE CAST(bdate AS DATE)
		END AS bdate,
        CASE 
            WHEN gen IS NULL OR TRIM(gen) = '' THEN 'n/a'
            WHEN UPPER(TRIM(gen)) = 'F' THEN 'Female'
            WHEN UPPER(TRIM(gen)) = 'M' THEN 'Male'
            ELSE TRIM(gen)
        END AS gen
    FROM bronze.erp_cust_az12 ;

    SET @end_time = SYSDATETIME();
    PRINT 'Completed silver.erp_cust_az12. Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR(10)) + ' seconds.';

    SET @start_time = SYSDATETIME();
    PRINT 'Loading data into: silver.erp_px_cat_g1v2...';

    TRUNCATE TABLE silver.erp_px_cat_g1v2;
    
    INSERT INTO silver.erp_px_cat_g1v2 (id, cat, subcate, maintenance)
    SELECT * FROM bronze.erp_px_cat_g1v2;

    SET @end_time = SYSDATETIME();
    PRINT 'Completed silver.erp_px_cat_g1v2. Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR(10)) + ' seconds.';

    SET @start_time = SYSDATETIME();
    PRINT 'Loading data into: silver.erp_loc_a101...';

    TRUNCATE TABLE silver.erp_loc_a101;
    
    INSERT INTO silver.erp_loc_a101 (cid, cntry)
    SELECT 
        TRIM(REPLACE(cid, '-', '')) AS cid, 
        CASE 
            WHEN cntry IS NULL OR TRIM(cntry) = '' THEN 'n/a'
            WHEN UPPER(TRIM(cntry)) IN ('US', 'UNITED KINGDOM') THEN 'United States' -- Handled uppercase logic
            WHEN UPPER(TRIM(cntry)) IN ('DE', 'GERMANY') THEN 'Germany'
            ELSE TRIM(cntry)
        END AS cntry
    FROM bronze.erp_loc_a101;

    SET @end_time = SYSDATETIME();
    PRINT 'Completed silver.erp_loc_a101. Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR(10)) + ' seconds.';

    SET @start_time = SYSDATETIME();
    PRINT 'Loading data into: silver.crm_cust_info...';

    TRUNCATE TABLE silver.crm_cust_info;
    
    INSERT INTO silver.crm_cust_info (cst_id, cst_key, cst_firstname, cst_lastname, cst_marital_status, cst_gndr, cst_create_date)
    SELECT 
        cst_id,
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

    SET @end_time = SYSDATETIME();
    PRINT 'Completed silver.crm_cust_info. Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR(10)) + ' seconds.';

    SET @start_time = SYSDATETIME();
    PRINT 'Loading data into: silver.crm_sales_details...';

    TRUNCATE TABLE silver.crm_sales_details;
    
    INSERT INTO silver.crm_sales_details (
        sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt, sls_ship_dt, sls_due_dt, sls_sales, sls_quantity, sls_price
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
            WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales <> sls_quantity * sls_price THEN sls_quantity * ABS(NULLIF(sls_price, 0))
            ELSE sls_sales
        END AS sls_sales,
        sls_quantity,
        CASE 
            WHEN sls_price IS NULL OR sls_price < 0 THEN ABS(NULLIF(sls_sales, 0)) / sls_quantity
            ELSE sls_price
        END AS sls_price
    FROM bronze.crm_sales_details;

    SET @end_time = SYSDATETIME();
    PRINT 'Completed silver.crm_sales_details. Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR(10)) + ' seconds.';
	    
    PRINT 'Loading data into: silver.crm_prd_info...';

    TRUNCATE TABLE silver.crm_prd_info;
    
    INSERT INTO silver.crm_prd_info (prd_id, cat_id, prd_key, prd_nm, prd_cost,prd_line, prd_start_dt,prd_end_dt)
	SELECT 
		prd_id,
		SUBSTRING(prd_key,1,5) as cat_id,
		SUBSTRING(prd_key,7,len(prd_key)) as prd_key,  
		prd_nm,
		ISNULL(prd_cost,0) as prd_cost,
		CASE 
				WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
				WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
				WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
				WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
				ELSE 'n/a'
			END AS prd_line,
		prd_start_dt,
		COALESCE (LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt ), prd_end_dt, CAST(GETDATE() AS DATE)) AS prd_end_dt
	FROM bronze.crm_prd_info


    SET @end_time = SYSDATETIME();
    PRINT 'Completed silver.erp_loc_a101. Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR(10)) + ' seconds.';
    SET @batch_end_time = SYSDATETIME();
    PRINT '==================================================';
    PRINT 'BATCH PROCESS COMPLETED SUCCESSFULLY AT: ' + CAST(@batch_end_time AS VARCHAR(30));
    PRINT 'TOTAL ELAPSED TIME: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS VARCHAR(10)) + ' seconds.';
    PRINT '==================================================';

END TRY 

    BEGIN CATCH

        PRINT 'PROCESS FAILED!';

        SELECT
            ERROR_NUMBER()    AS ErrorNumber,
            ERROR_LINE()      AS ErrorLine,
            ERROR_PROCEDURE() AS ErrorProcedure,
            ERROR_MESSAGE()   AS ErrorMessage;

        THROW;

    END CATCH
END;
GO

-- Usage : 
-- EXEC silver.load_silver;

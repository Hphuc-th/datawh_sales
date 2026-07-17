CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	BEGIN TRY 
		DECLARE @batch_start_time DATETIME, @batch_end_time DATETIME, @start_time DATETIME,@end_time DATETIME
		SET @batch_start_time = SYSDATETIME()
		PRINT (' Start loading data into bronze layer at'+ CONVERT(VARCHAR(30), @batch_start_time, 120));
		PRINT ('=============================================================');

		PRINT (' Inserting data into : bronze.erp_cust_az12');
		SET @start_time= SYSDATETIME();
		TRUNCATE TABLE bronze.erp_cust_az12;
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\phuch\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH ( FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				FORMAT ='CSV');
		SET @end_time= SYSDATETIME();
		PRINT ('Load duration: '+ CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) +'seconds');

		PRINT (' Inserting data into : bronze.erp_loc_a101');
		SET @start_time= SYSDATETIME();
		TRUNCATE TABLE bronze.erp_loc_a101;
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\phuch\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH ( FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				FORMAT ='CSV');
		SET @end_time= SYSDATETIME();
		PRINT ('Load duration: '+ CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) +'seconds');

		PRINT (' Inserting data into : bronze.erp_px_cat_g1v2');
		SET @start_time= SYSDATETIME();
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\phuch\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH ( FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				FORMAT ='CSV');
		SET @end_time= SYSDATETIME();
		PRINT ('Load duration: '+ CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) +'seconds');

		PRINT '==========================================' 
		PRINT (' Inserting data into : bronze.crm_cust_info');
		SET @start_time= SYSDATETIME();
		TRUNCATE TABLE bronze.crm_cust_info;
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\phuch\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH ( FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				FORMAT ='CSV');
		SET @end_time= SYSDATETIME();
		PRINT ('Load duration: '+ CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) +'seconds');

		PRINT (' Inserting data into : bronze.crm_prd_info');
		SET @start_time= SYSDATETIME();
		TRUNCATE TABLE bronze.crm_prd_info;
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\phuch\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH ( FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				FORMAT ='CSV');
		SET @end_time= SYSDATETIME();
		PRINT ('Load duration: '+ CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) +'seconds');

		PRINT (' Inserting data into : bronze.crm_sales_details');
		SET @start_time= SYSDATETIME();
		TRUNCATE TABLE bronze.crm_sales_details;
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\phuch\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH ( FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				FORMAT ='CSV');
		SET @end_time= SYSDATETIME();
		PRINT ('Load duration: '+ CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) +'seconds');
		PRINT (' Batch load duration '+ CAST(DATEDIFF(SECOND,@start_time, @end_time) AS NVARCHAR) +'seconds');
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END



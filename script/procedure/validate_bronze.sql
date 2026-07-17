/**
Purpose:
    Validates the completeness of a Bronze table by comparing the actual
    number of records with the expected number of records.

    This procedure is intended to be executed after the data loading process
    to ensure that all records have been successfully imported into the
    target Bronze table.

Parameters:
    @table_check   VARCHAR(50)
        - Fully table name to validate.

    @record_count  INT
        - Expected number of records in the table after loading.

Output:
    - Prints the validation result containing:
        * Validation status (PASS / FAIL)
        * Table name
        * Expected record count
        * Actual record count

Return:
    None.

Usage:
    EXEC bronze.validation_completeness_bronze
        @table_check = 'bronze.erp_cust_az12',
        @record_count = 18484;
**/
CREATE OR ALTER PROCEDURE bronze.validate_completeness_bronze 
    @table_check VARCHAR(50),
    @record_count INT 
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX) = N'
        DECLARE @c INT;
        SELECT @c = COUNT(*) FROM ' + @table_check + N';

        IF @c = @r
        BEGIN
            PRINT ''--- VALIDATION SUCCESS ---'';
            PRINT ''Table: ' + @table_check + N' | Status: PASS'';
            PRINT ''Expected: '' + CAST(@r AS VARCHAR) + '' | Actual: '' + CAST(@c AS VARCHAR);
        END
        ELSE
        BEGIN
            PRINT ''--- VALIDATION FAILED ---'';
            PRINT ''Table: ' + @table_check + N' | Status: FAIL'';
            PRINT ''Expected: '' + CAST(@r AS VARCHAR) + '' | Actual: '' + CAST(@c AS VARCHAR);
        END;
    ';

    EXEC sp_executesql @SQL, N'@r INT', @r = @record_count;
END;
GO
CREATE OR ALTER PROCEDURE bronze.validate_bronze
AS
BEGIN
    BEGIN TRY

        DECLARE
            @batch_start_time DATETIME2,
            @batch_end_time   DATETIME2,
            @start_time       DATETIME2,
            @end_time         DATETIME2;

        SET @batch_start_time = SYSDATETIME();

        PRINT 'Start validating bronze layer at '
            + CONVERT(VARCHAR(30), @batch_start_time, 120);
        PRINT '=================================================';

        PRINT 'Validating : bronze.erp_cust_az12';
        SET @start_time = SYSDATETIME();

        EXEC bronze.validate_completeness_bronze
            @table_check = 'bronze.erp_cust_az12',
            @record_count = 18484;

        SET @end_time = SYSDATETIME();

        PRINT 'Validation duration: '
            + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS VARCHAR)
            + ' seconds';

        PRINT 'Validating : bronze.erp_loc_a101';
        SET @start_time = SYSDATETIME();

        EXEC bronze.validate_completeness_bronze 
            @table_check = 'bronze.erp_loc_a101',
            @record_count = 18484;

        SET @end_time = SYSDATETIME();

        PRINT 'Validation duration: '
            + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS VARCHAR)
            + ' seconds';

        ------------------------------------------------------------
        -- ERP CATEGORY
        ------------------------------------------------------------
        PRINT 'Validating : bronze.erp_px_cat_g1v2';
        SET @start_time = SYSDATETIME();

        EXEC bronze.validate_completeness_bronze 
            @table_check = 'bronze.erp_px_cat_g1v2',
            @record_count = 37;

        SET @end_time = SYSDATETIME();

        PRINT 'Validation duration: '
            + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS VARCHAR)
            + ' seconds';

        ------------------------------------------------------------
        -- CRM CUSTOMER
        ------------------------------------------------------------
        PRINT 'Validating : bronze.crm_cust_info';
        SET @start_time = SYSDATETIME();

        EXEC bronze.validate_completeness_bronze 
            @table_check = 'bronze.crm_cust_info',
            @record_count = 18494;

        SET @end_time = SYSDATETIME();

        PRINT 'Validation duration: '
            + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS VARCHAR)
            + ' seconds';

        ------------------------------------------------------------
        -- CRM PRODUCT
        ------------------------------------------------------------
        PRINT 'Validating : bronze.crm_prd_info';
        SET @start_time = SYSDATETIME();

        EXEC bronze.validate_completeness_bronze 
            @table_check = 'bronze.crm_prd_info',
            @record_count = 397;

        SET @end_time = SYSDATETIME();

        PRINT 'Validation duration: '
            + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS VARCHAR)
            + ' seconds';

        ------------------------------------------------------------
        -- CRM SALES
        ------------------------------------------------------------
        PRINT 'Validating : bronze.crm_sales_details';
        SET @start_time = SYSDATETIME();

        EXEC bronze.validate_completeness_bronze 
            @table_check = 'bronze.crm_sales_details',
            @record_count = 60398;

        SET @end_time = SYSDATETIME();

        PRINT 'Validation duration: '
            + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS VARCHAR)
            + ' seconds';

        ------------------------------------------------------------

        SET @batch_end_time = SYSDATETIME();

        PRINT '=================================================';
        PRINT 'Bronze validation completed successfully.';
        PRINT 'Batch validation duration: '
            + CAST(DATEDIFF(SECOND,@batch_start_time,@batch_end_time) AS VARCHAR)
            + ' seconds';
        PRINT '=================================================';

    END TRY

    BEGIN CATCH

        PRINT '=================================================';
        PRINT 'ERROR OCCURRED DURING BRONZE VALIDATION';
        PRINT 'Error Message : ' + ERROR_MESSAGE();
        PRINT 'Error Number  : ' + CAST(ERROR_NUMBER() AS VARCHAR);
        PRINT 'Error State   : ' + CAST(ERROR_STATE() AS VARCHAR);
        PRINT '=================================================';

    END CATCH
END;
GO

EXEC bronze.validate_bronze;

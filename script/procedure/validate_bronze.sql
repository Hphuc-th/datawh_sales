CREATE OR ALTER PROCEDURE bronze.validation_completeness_bronze 
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

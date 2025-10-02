-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Verify backup integrity by comparing row counts and basic structure
-- Sample:		SELECT [dbo].[ZzVerifyBackup]('Users', 'UserBackups_20241002');
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzVerifyBackup(
    @source_table NVARCHAR(128),
    @backup_table NVARCHAR(128)
)
RETURNS NVARCHAR(500)
AS
BEGIN
    DECLARE @result NVARCHAR(500);
    DECLARE @source_count INT;
    DECLARE @backup_count INT;
    DECLARE @source_columns INT;
    DECLARE @backup_columns INT;
    
    -- Check if both tables exist
    IF OBJECT_ID(@source_table, 'U') IS NULL
        RETURN 'ERROR: Source table ' + @source_table + ' does not exist.';
    
    IF OBJECT_ID(@backup_table, 'U') IS NULL
        RETURN 'ERROR: Backup table ' + @backup_table + ' does not exist.';
    
    BEGIN TRY
        -- Get row counts
        DECLARE @sql NVARCHAR(500);
        
        SET @sql = 'SELECT @count = COUNT(*) FROM [' + @source_table + ']';
        EXEC sp_executesql @sql, N'@count INT OUTPUT', @source_count OUTPUT;
        
        SET @sql = 'SELECT @count = COUNT(*) FROM [' + @backup_table + ']';
        EXEC sp_executesql @sql, N'@count INT OUTPUT', @backup_count OUTPUT;
        
        -- Get column counts (excluding backup metadata columns)
        SELECT @source_columns = COUNT(*)
        FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = @source_table;
        
        SELECT @backup_columns = COUNT(*)
        FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = @backup_table
        AND COLUMN_NAME NOT IN ('ZzBackupDate', 'ZzSourceTable');
        
        -- Verify integrity
        IF @source_count = @backup_count AND @source_columns = @backup_columns
            SET @result = 'PASS: Backup verification successful. Rows: ' + CAST(@source_count AS NVARCHAR(10));
        ELSE IF @source_columns != @backup_columns
            SET @result = 'FAIL: Column count mismatch. Source: ' + CAST(@source_columns AS NVARCHAR(10)) + ', Backup: ' + CAST(@backup_columns AS NVARCHAR(10));
        ELSE
            SET @result = 'FAIL: Row count mismatch. Source: ' + CAST(@source_count AS NVARCHAR(10)) + ', Backup: ' + CAST(@backup_count AS NVARCHAR(10));
            
    END TRY
    BEGIN CATCH
        SET @result = 'ERROR: ' + ERROR_MESSAGE();
    END CATCH
    
    RETURN @result;
END
GO
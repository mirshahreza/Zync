-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Create backup copy of a table with timestamp
-- Sample:		EXEC [dbo].[ZzBackupTable] 'Users', 'UserBackups';
-- =============================================
CREATE OR ALTER PROCEDURE dbo.ZzBackupTable
    @source_table NVARCHAR(128),
    @backup_prefix NVARCHAR(128) = NULL,
    @include_data BIT = 1,
    @backup_table_name NVARCHAR(128) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @sql NVARCHAR(MAX);
    DECLARE @timestamp NVARCHAR(20);
    DECLARE @error_msg NVARCHAR(500);
    
    BEGIN TRY
        -- Validate source table exists
        IF OBJECT_ID(@source_table, 'U') IS NULL
        BEGIN
            SET @error_msg = 'Source table ' + @source_table + ' does not exist.';
            RAISERROR(@error_msg, 16, 1);
            RETURN;
        END
        
        -- Generate timestamp
        SET @timestamp = FORMAT(GETDATE(), 'yyyyMMdd_HHmmss');
        
        -- Generate backup table name
        IF @backup_prefix IS NULL
            SET @backup_prefix = @source_table + '_backup';
            
        SET @backup_table_name = @backup_prefix + '_' + @timestamp;
        
        -- Create backup table structure
        SET @sql = 'SELECT TOP 0 * INTO [' + @backup_table_name + '] FROM [' + @source_table + ']';
        EXEC sp_executesql @sql;
        
        -- Copy data if requested
        IF @include_data = 1
        BEGIN
            SET @sql = 'INSERT INTO [' + @backup_table_name + '] SELECT * FROM [' + @source_table + ']';
            EXEC sp_executesql @sql;
        END
        
        -- Add backup metadata columns
        SET @sql = 'ALTER TABLE [' + @backup_table_name + '] ADD 
                    ZzBackupDate DATETIME2 DEFAULT GETDATE(),
                    ZzSourceTable NVARCHAR(128) DEFAULT ''' + @source_table + '''';
        EXEC sp_executesql @sql;
        
        PRINT 'Backup created successfully: ' + @backup_table_name;
        
    END TRY
    BEGIN CATCH
        SET @error_msg = 'Error creating backup: ' + ERROR_MESSAGE();
        RAISERROR(@error_msg, 16, 1);
    END CATCH
END
GO
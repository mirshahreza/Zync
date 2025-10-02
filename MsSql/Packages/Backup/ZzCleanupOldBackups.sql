-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Remove old backup tables based on retention policy
-- Sample:		EXEC [dbo].[ZzCleanupOldBackups] 'UserBackups', 30;
-- =============================================
CREATE OR ALTER PROCEDURE dbo.ZzCleanupOldBackups
    @backup_prefix NVARCHAR(128),
    @retention_days INT = 30,
    @dry_run BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @sql NVARCHAR(MAX);
    DECLARE @table_name NVARCHAR(128);
    DECLARE @creation_date DATETIME;
    DECLARE @cutoff_date DATETIME;
    DECLARE @deleted_count INT = 0;
    
    SET @cutoff_date = DATEADD(DAY, -@retention_days, GETDATE());
    
    DECLARE backup_cursor CURSOR FOR
    SELECT 
        t.name,
        t.create_date
    FROM sys.tables t
    WHERE t.name LIKE @backup_prefix + '_%'
    AND t.create_date < @cutoff_date;
    
    OPEN backup_cursor;
    FETCH NEXT FROM backup_cursor INTO @table_name, @creation_date;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF @dry_run = 1
        BEGIN
            PRINT 'Would delete: ' + @table_name + ' (created: ' + CONVERT(NVARCHAR(20), @creation_date, 120) + ')';
        END
        ELSE
        BEGIN
            SET @sql = 'DROP TABLE [' + @table_name + ']';
            
            BEGIN TRY
                EXEC sp_executesql @sql;
                PRINT 'Deleted backup table: ' + @table_name;
                SET @deleted_count = @deleted_count + 1;
            END TRY
            BEGIN CATCH
                PRINT 'Failed to delete: ' + @table_name + ' - ' + ERROR_MESSAGE();
            END CATCH
        END
        
        FETCH NEXT FROM backup_cursor INTO @table_name, @creation_date;
    END
    
    CLOSE backup_cursor;
    DEALLOCATE backup_cursor;
    
    IF @dry_run = 1
        PRINT 'Dry run completed. Use @dry_run = 0 to actually delete tables.';
    ELSE
        PRINT 'Cleanup completed. Deleted ' + CAST(@deleted_count AS NVARCHAR(10)) + ' backup tables.';
END
GO
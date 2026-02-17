-- =============================================
-- Complete Cleanup: Remove Elsa Package & Tables
-- =============================================
PRINT '========================================='
PRINT 'Complete Cleanup: Removing Elsa'
PRINT '========================================='

SET NOCOUNT ON

BEGIN TRY
    -- Step 0: Drop ALL foreign key constraints dynamically
    PRINT ''
    PRINT 'Step 0: Dropping all foreign key constraints...'
    DECLARE @DropFKs NVARCHAR(MAX) = ''
    
    SELECT @DropFKs = @DropFKs + 'ALTER TABLE [' + TABLE_SCHEMA + '].[' + TABLE_NAME + '] DROP CONSTRAINT [' + CONSTRAINT_NAME + '];' + CHAR(13)
    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_TYPE = 'FOREIGN KEY'
    
    IF LEN(@DropFKs) > 0
    BEGIN
        EXEC sp_executesql @DropFKs
        PRINT 'All foreign key constraints dropped.'
    END
    ELSE
    BEGIN
        PRINT 'No foreign key constraints found.'
    END
    
    -- Step 1: Drop all Elsa views
    PRINT ''
    PRINT 'Step 1: Dropping Elsa views...'
    DECLARE @DropViewSql NVARCHAR(MAX) = ''
    SELECT @DropViewSql = @DropViewSql + 'DROP VIEW IF EXISTS [dbo].[' + TABLE_NAME + '];' + CHAR(13)
    FROM INFORMATION_SCHEMA.VIEWS
    WHERE TABLE_SCHEMA = 'dbo'
    AND TABLE_NAME LIKE '%Elsa%'
    
    IF LEN(@DropViewSql) > 0
    BEGIN
        EXEC sp_executesql @DropViewSql
        PRINT 'Elsa views dropped.'
    END
    ELSE
    BEGIN
        PRINT 'No Elsa views found.'
    END
    
    -- Step 2: Drop all Elsa tables
    PRINT ''
    PRINT 'Step 2: Dropping Elsa tables...'
    DROP TABLE IF EXISTS [dbo].[ElsaWorkflowExecutionLogRecords]
    DROP TABLE IF EXISTS [dbo].[ElsaStoredBookmarks]
    DROP TABLE IF EXISTS [dbo].[ElsaBookmarks]
    DROP TABLE IF EXISTS [dbo].[ElsaActivityInstances]
    DROP TABLE IF EXISTS [dbo].[ElsaWorkflowInstances]
    DROP TABLE IF EXISTS [dbo].[ElsaWorkflowDefinitionLabels]
    DROP TABLE IF EXISTS [dbo].[ElsaLabels]
    DROP TABLE IF EXISTS [dbo].[ElsaWorkflowDefinitions]
    PRINT 'Elsa tables dropped.'
    
    -- Step 3: Delete Elsa objects from ZyncObjects
    PRINT ''
    PRINT 'Step 3: Removing Elsa objects from ZyncObjects...'
    DELETE FROM [dbo].[ZyncObjects]
    WHERE PackageId IN (SELECT PackageId FROM [dbo].[ZyncPackages] WHERE PackageName = 'Elsa')
    PRINT 'Deleted ' + CAST(@@ROWCOUNT AS NVARCHAR(10)) + ' objects.'
    
    -- Step 4: Delete Elsa package record
    PRINT ''
    PRINT 'Step 4: Removing Elsa from ZyncPackages...'
    DELETE FROM [dbo].[ZyncPackages]
    WHERE PackageName = 'Elsa'
    PRINT 'Deleted ' + CAST(@@ROWCOUNT AS NVARCHAR(10)) + ' package record(s).'
    
    -- Step 5: Re-create all foreign key constraints
    PRINT ''
    PRINT 'Step 5: Re-creating all foreign key constraints...'
    -- Re-create FK from ZyncObjects to ZyncPackages
    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_NAME = 'FK_ZyncObjects_ZyncPackages')
    BEGIN
        ALTER TABLE [dbo].[ZyncObjects]
        ADD CONSTRAINT FK_ZyncObjects_ZyncPackages FOREIGN KEY (PackageId)
        REFERENCES [dbo].[ZyncPackages](PackageId) ON DELETE CASCADE
        PRINT 'Foreign key constraint recreated.'
    END
    
    PRINT ''
    PRINT 'SUCCESS: Complete cleanup finished. You can now reinstall Elsa.'
    PRINT '========================================='
    
END TRY
BEGIN CATCH
    PRINT 'ERROR: ' + ERROR_MESSAGE()
    PRINT '========================================='
END CATCH

-- =============================================
-- Cleanup Script: Remove Elsa Package Completely
-- =============================================
PRINT '========================================='
PRINT 'Cleaning up Elsa Package'
PRINT '========================================='

SET NOCOUNT ON

-- Step 1: Delete from ZyncObjects
PRINT ''
PRINT 'Step 1: Removing Elsa objects from ZyncObjects...'
DELETE FROM [dbo].[ZyncObjects]
WHERE PackageId IN (SELECT PackageId FROM [dbo].[ZyncPackages] WHERE PackageName LIKE 'Elsa%')
PRINT 'Deleted ' + CAST(@@ROWCOUNT AS NVARCHAR(10)) + ' records.'

-- Step 2: Delete from ZyncPackages (remove all Elsa entries)
PRINT ''
PRINT 'Step 2: Removing all Elsa entries from ZyncPackages...'
DELETE FROM [dbo].[ZyncPackages]
WHERE PackageName LIKE 'Elsa%'
PRINT 'Deleted ' + CAST(@@ROWCOUNT AS NVARCHAR(10)) + ' package records.'

-- Step 3: Drop all Elsa tables
PRINT ''
PRINT 'Step 3: Dropping Elsa tables...'
DROP TABLE IF EXISTS [dbo].[ElsaWorkflowDefinitions]
DROP TABLE IF EXISTS [dbo].[ElsaWorkflowInstances]
DROP TABLE IF EXISTS [dbo].[ElsaActivityInstances]
DROP TABLE IF EXISTS [dbo].[ElsaBookmarks]
DROP TABLE IF EXISTS [dbo].[ElsaWorkflowExecutionLogRecords]
DROP TABLE IF EXISTS [dbo].[ElsaLabels]
DROP TABLE IF EXISTS [dbo].[ElsaWorkflowDefinitionLabels]
DROP TABLE IF EXISTS [dbo].[ElsaStoredBookmarks]
DROP TABLE IF EXISTS [dbo].[ElsaWorkflowTasks]
PRINT 'All Elsa tables removed.'

-- Step 4: Build and execute dynamic DROP VIEW statements
PRINT ''
PRINT 'Step 4: Dropping Elsa views...'
DECLARE @DropViewSql NVARCHAR(MAX) = ''

SELECT @DropViewSql = @DropViewSql + 'DROP VIEW [dbo].[' + TABLE_NAME + '];' + CHAR(13)
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_SCHEMA = 'dbo'
AND (TABLE_NAME LIKE '%Elsa%' OR TABLE_NAME LIKE 'Zz%Elsa%')

IF LEN(@DropViewSql) > 0
BEGIN
    EXEC sp_executesql @DropViewSql
    PRINT 'All Elsa views removed.'
END
ELSE
    PRINT 'No Elsa views found.'

-- Step 5: Build and execute dynamic DROP PROCEDURE statements
PRINT ''
PRINT 'Step 5: Dropping Elsa procedures...'
DECLARE @DropProcSql NVARCHAR(MAX) = ''

SELECT @DropProcSql = @DropProcSql + 'DROP PROCEDURE [dbo].[' + name + '];' + CHAR(13)
FROM sys.objects
WHERE type = 'P'
AND (name LIKE '%Elsa%' OR name LIKE 'ZzElsa%')

IF LEN(@DropProcSql) > 0
BEGIN
    EXEC sp_executesql @DropProcSql
    PRINT 'All Elsa procedures removed.'
END
ELSE
    PRINT 'No Elsa procedures found.'

-- Step 6: Build and execute dynamic DROP FUNCTION statements
PRINT ''
PRINT 'Step 6: Dropping Elsa functions...'
DECLARE @DropFuncSql NVARCHAR(MAX) = ''

SELECT @DropFuncSql = @DropFuncSql + 'DROP FUNCTION [dbo].[' + name + '];' + CHAR(13)
FROM sys.objects
WHERE type IN ('FN', 'TF', 'IF')
AND (name LIKE '%Elsa%' OR name LIKE 'ZzElsa%')

IF LEN(@DropFuncSql) > 0
BEGIN
    EXEC sp_executesql @DropFuncSql
    PRINT 'All Elsa functions removed.'
END
ELSE
    PRINT 'No Elsa functions found.'

SET NOCOUNT OFF
PRINT ''
PRINT '========================================='
PRINT 'Elsa cleanup completed successfully!'
PRINT 'You can now reinstall the Elsa package.'
PRINT '========================================='

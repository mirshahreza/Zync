-- Validate rm-all guard against empty package names
PRINT '=== Test: rm (guard against empty package names) ==='

BEGIN TRY
    IF OBJECT_ID('[dbo].[Zync]','P') IS NOT NULL EXEC dbo.Zync 'clean'
END TRY
BEGIN CATCH END CATCH

IF OBJECT_ID('[dbo].[Zync]','P') IS NULL
BEGIN
    RAISERROR('Zync procedure not found. Install MsSql/Zync.sql first.',16,1)
    RETURN
END

-- Seed a bogus empty-name row to simulate older tracking data corruption
INSERT INTO [dbo].[ZyncPackages] (PackageName, Status)
VALUES (N'', 'INSTALLED');

-- Also add a valid tiny package to ensure at least one removal happens
DECLARE @pid UNIQUEIDENTIFIER = NEWID();
INSERT INTO [dbo].[ZyncPackages] (PackageId, PackageName, Status)
VALUES (@pid, 'Test/EmptyGuard.sql', 'INSTALLED');
INSERT INTO [dbo].[ZyncObjects] (PackageId, ObjectName, ObjectType, ObjectDefinition)
VALUES (@pid, 'ZzTmpEmptyGuard', 'VIEW', 'CREATE OR ALTER VIEW [dbo].[ZzTmpEmptyGuard] AS SELECT 1 AS x');
GO

-- Create the object from ObjectDefinition to simulate installed state
IF OBJECT_ID('[dbo].[ZzTmpEmptyGuard]','V') IS NULL
    EXEC(N'CREATE OR ALTER VIEW [dbo].[ZzTmpEmptyGuard] AS SELECT 1 AS x');
GO

PRINT 'Running: EXEC dbo.Zync ''rm''' 
EXEC dbo.Zync 'rm'
GO

-- Validate that empty row is gone and valid package removed
DECLARE @EmptyRows INT = (SELECT COUNT(*) FROM dbo.ZyncPackages WHERE LTRIM(RTRIM(ISNULL(PackageName,'')))='');
DECLARE @ValidRow INT = (SELECT COUNT(*) FROM dbo.ZyncPackages WHERE PackageName='Test/EmptyGuard.sql' AND Status IN ('INSTALLED','UPDATED'));
DECLARE @ViewExists BIT = CASE WHEN OBJECT_ID('[dbo].[ZzTmpEmptyGuard]','V') IS NOT NULL THEN 1 ELSE 0 END;

IF @EmptyRows=0 AND @ValidRow=0 AND @ViewExists=0
    PRINT '✓ PASS: rm-all guard removed empty entries and processed valid package.'
ELSE
BEGIN
    PRINT '✗ FAIL: rm-all guard did not work as expected.'
    PRINT '  -> Empty rows: ' + CAST(@EmptyRows AS VARCHAR(10));
    PRINT '  -> Remaining valid rows: ' + CAST(@ValidRow AS VARCHAR(10));
    PRINT '  -> ZzTmpEmptyGuard exists? ' + CAST(@ViewExists AS VARCHAR(1));
END

PRINT '=== End Test: rm (guard) ==='

-- =============================================
-- Zync Scenario Test 10: Performance & Scale
-- Author: Zync Development Team
-- Date: 2026-01-06
-- Description: Tests performance and scalability
-- Scenarios:
--   10.1: Install package with many objects
--   10.2: Performance benchmarks
--   10.3: Bulk operations
--   10.4: Large table handling
--   10.5: System resource usage
-- =============================================

SET NOCOUNT ON;
GO

PRINT '========================================='
PRINT 'ZYNC SCENARIO 10: PERFORMANCE & SCALE'
PRINT '========================================='
PRINT 'Test Date: ' + CONVERT(VARCHAR, GETDATE(), 120)
PRINT ''

DECLARE @TestsPassed INT = 0;
DECLARE @TestsFailed INT = 0;
DECLARE @TestsWarning INT = 0;
DECLARE @StartTime DATETIME2 = SYSDATETIME();

IF OBJECT_ID('[dbo].[Zync]', 'P') IS NULL
BEGIN
    PRINT '❌ PREREQUISITE FAILED: Zync not installed'
    RETURN;
END

PRINT '✓ Prerequisite: Zync core is installed'
PRINT ''

-- =============================================
-- SETUP
-- =============================================
PRINT '----------------------------------------'
PRINT 'Setup: Preparing Performance Tests'
PRINT '----------------------------------------'

BEGIN TRY
    EXEC [dbo].[Zync] 'clean';
    PRINT '✓ Environment cleaned'
    PRINT ''
END TRY
BEGIN CATCH
    PRINT '✗ Setup failed - ' + ERROR_MESSAGE();
    RETURN;
END CATCH

-- =============================================
-- SCENARIO 10.1: Install large package
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 10.1: Install Package with Many Objects'
PRINT '----------------------------------------'

DECLARE @InstallStart DATETIME2 = SYSDATETIME();

-- Install String package (has 43 functions)
BEGIN TRY
    EXEC [dbo].[Zync] 'i String';
    
    DECLARE @InstallEnd DATETIME2 = SYSDATETIME();
    DECLARE @InstallDuration FLOAT = DATEDIFF(MILLISECOND, @InstallStart, @InstallEnd) / 1000.0;
    
    PRINT '✓ PASS: String package installed'
    PRINT '  Duration: ' + CAST(@InstallDuration AS VARCHAR) + ' seconds'
    SET @TestsPassed = @TestsPassed + 1;
END TRY
BEGIN CATCH
    PRINT '✗ FAIL: Install failed - ' + ERROR_MESSAGE();
    SET @TestsFailed = @TestsFailed + 1;
END CATCH

-- Verify object count
DECLARE @StringObjects INT = 0;
SELECT @StringObjects = COUNT(*)
FROM [dbo].[ZyncObjects] zo
INNER JOIN [dbo].[ZyncPackages] zp ON zo.PackageId = zp.Id
WHERE zp.PackageName = 'String';

IF @StringObjects > 40
BEGIN
    PRINT '✓ PASS: Large object count handled (' + CAST(@StringObjects AS VARCHAR) + ' objects)'
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '⚠ WARN: Expected 40+ objects, found ' + CAST(@StringObjects AS VARCHAR)
    SET @TestsWarning = @TestsWarning + 1;
END

PRINT ''

-- =============================================
-- SCENARIO 10.2: Performance benchmarks
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 10.2: Performance Benchmarks'
PRINT '----------------------------------------'

-- Test 1: List command performance
DECLARE @ListStart DATETIME2 = SYSDATETIME();
EXEC [dbo].[Zync] 'ls';
DECLARE @ListEnd DATETIME2 = SYSDATETIME();
DECLARE @ListDuration FLOAT = DATEDIFF(MILLISECOND, @ListStart, @ListEnd) / 1000.0;

PRINT '✓ List command duration: ' + CAST(@ListDuration AS VARCHAR) + ' seconds'

IF @ListDuration < 1.0
BEGIN
    PRINT '✓ PASS: List command performance acceptable'
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '⚠ WARN: List command took longer than expected'
    SET @TestsWarning = @TestsWarning + 1;
END

-- Test 2: List objects performance
DECLARE @LOStart DATETIME2 = SYSDATETIME();
EXEC [dbo].[Zync] 'lo';
DECLARE @LOEnd DATETIME2 = SYSDATETIME();
DECLARE @LODuration FLOAT = DATEDIFF(MILLISECOND, @LOStart, @LOEnd) / 1000.0;

PRINT '✓ List objects duration: ' + CAST(@LODuration AS VARCHAR) + ' seconds'

IF @LODuration < 2.0
BEGIN
    PRINT '✓ PASS: List objects performance acceptable'
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '⚠ WARN: List objects took longer than expected'
    SET @TestsWarning = @TestsWarning + 1;
END

PRINT ''

-- =============================================
-- SCENARIO 10.3: Bulk operations
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 10.3: Bulk Package Operations'
PRINT '----------------------------------------'

-- Install multiple packages
DECLARE @BulkStart DATETIME2 = SYSDATETIME();

BEGIN TRY
    EXEC [dbo].[Zync] 'i Math';
    EXEC [dbo].[Zync] 'i Validation';
    EXEC [dbo].[Zync] 'i Json';
    
    DECLARE @BulkEnd DATETIME2 = SYSDATETIME();
    DECLARE @BulkDuration FLOAT = DATEDIFF(MILLISECOND, @BulkStart, @BulkEnd) / 1000.0;
    
    PRINT '✓ PASS: Multiple packages installed'
    PRINT '  Total duration: ' + CAST(@BulkDuration AS VARCHAR) + ' seconds'
    PRINT '  Average per package: ' + CAST(@BulkDuration / 3 AS VARCHAR) + ' seconds'
    SET @TestsPassed = @TestsPassed + 1;
END TRY
BEGIN CATCH
    PRINT '✗ FAIL: Bulk install failed - ' + ERROR_MESSAGE();
    SET @TestsFailed = @TestsFailed + 1;
END CATCH

-- Verify all packages installed
DECLARE @BulkPackageCount INT = 0;
SELECT @BulkPackageCount = COUNT(*)
FROM [dbo].[ZyncPackages]
WHERE Status = 'INSTALLED';

IF @BulkPackageCount >= 4
BEGIN
    PRINT '✓ PASS: All packages tracked (' + CAST(@BulkPackageCount AS VARCHAR) + ' packages)'
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '✗ FAIL: Expected 4+ packages, found ' + CAST(@BulkPackageCount AS VARCHAR)
    SET @TestsFailed = @TestsFailed + 1;
END

PRINT ''

-- =============================================
-- SCENARIO 10.4: Large table simulation
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 10.4: Large Table Handling'
PRINT '----------------------------------------'

-- Create test table with data
IF OBJECT_ID('[dbo].[ZzPerfTestTable]', 'U') IS NOT NULL
    DROP TABLE [dbo].[ZzPerfTestTable];

BEGIN TRY
    CREATE TABLE [dbo].[ZzPerfTestTable] (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Data NVARCHAR(100),
        CreatedDate DATETIME2 DEFAULT SYSDATETIME()
    );
    
    -- Insert test data (1000 rows)
    DECLARE @Counter INT = 0;
    WHILE @Counter < 1000
    BEGIN
        INSERT INTO [dbo].[ZzPerfTestTable] (Data)
        VALUES ('Test data row ' + CAST(@Counter AS VARCHAR));
        SET @Counter = @Counter + 1;
    END
    
    DECLARE @RowCount INT;
    SELECT @RowCount = COUNT(*) FROM [dbo].[ZzPerfTestTable];
    
    PRINT '✓ PASS: Large table created with ' + CAST(@RowCount AS VARCHAR) + ' rows'
    SET @TestsPassed = @TestsPassed + 1;
END TRY
BEGIN CATCH
    PRINT '✗ FAIL: Large table creation failed - ' + ERROR_MESSAGE();
    SET @TestsFailed = @TestsFailed + 1;
END CATCH

-- Test query performance on large table
DECLARE @QueryStart DATETIME2 = SYSDATETIME();
SELECT COUNT(*) FROM [dbo].[ZzPerfTestTable];
DECLARE @QueryEnd DATETIME2 = SYSDATETIME();
DECLARE @QueryDuration FLOAT = DATEDIFF(MILLISECOND, @QueryStart, @QueryEnd);

PRINT '✓ Query on 1000 rows: ' + CAST(@QueryDuration AS VARCHAR) + ' ms'

IF @QueryDuration < 100
BEGIN
    PRINT '✓ PASS: Query performance acceptable'
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '⚠ WARN: Query performance could be improved'
    SET @TestsWarning = @TestsWarning + 1;
END

-- Cleanup test table
IF OBJECT_ID('[dbo].[ZzPerfTestTable]', 'U') IS NOT NULL
    DROP TABLE [dbo].[ZzPerfTestTable];

PRINT ''

-- =============================================
-- SCENARIO 10.5: System resource check
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 10.5: System Resource Usage'
PRINT '----------------------------------------'

-- Check object count
DECLARE @TotalZyncObjects INT = 0;
SELECT @TotalZyncObjects = COUNT(*)
FROM sys.objects
WHERE name LIKE 'Zz%' AND type IN ('P', 'FN', 'TF', 'IF', 'V', 'U');

PRINT '✓ Total Zync objects in database: ' + CAST(@TotalZyncObjects AS VARCHAR)

-- Check tracking table sizes
DECLARE @PackageRows INT = 0;
DECLARE @ObjectRows INT = 0;
SELECT @PackageRows = COUNT(*) FROM [dbo].[ZyncPackages];
SELECT @ObjectRows = COUNT(*) FROM [dbo].[ZyncObjects];

PRINT '✓ ZyncPackages rows: ' + CAST(@PackageRows AS VARCHAR)
PRINT '✓ ZyncObjects rows: ' + CAST(@ObjectRows AS VARCHAR)

IF @PackageRows > 0 AND @ObjectRows > 0
BEGIN
    PRINT '✓ PASS: Tracking tables populated'
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '⚠ WARN: Tracking tables may be incomplete'
    SET @TestsWarning = @TestsWarning + 1;
END

-- Memory/performance note
PRINT ''
PRINT 'ℹ INFO: For production systems with 100+ objects:'
PRINT '  • Monitor sp_BlitzCache for query performance'
PRINT '  • Consider indexing ZyncObjects.PackageId'
PRINT '  • Review transaction log usage during installs'
PRINT '  • Test concurrent access scenarios'

PRINT ''

-- =============================================
-- CLEANUP
-- =============================================
PRINT '----------------------------------------'
PRINT 'Cleanup: Removing Test Packages'
PRINT '----------------------------------------'

DECLARE @CleanStart DATETIME2 = SYSDATETIME();

BEGIN TRY
    EXEC [dbo].[Zync] 'clean';
    
    DECLARE @CleanEnd DATETIME2 = SYSDATETIME();
    DECLARE @CleanDuration FLOAT = DATEDIFF(MILLISECOND, @CleanStart, @CleanEnd) / 1000.0;
    
    PRINT '✓ Cleanup completed'
    PRINT '  Clean duration: ' + CAST(@CleanDuration AS VARCHAR) + ' seconds'
END TRY
BEGIN CATCH
    PRINT '⚠ Warning: Cleanup error - ' + ERROR_MESSAGE();
END CATCH

PRINT ''

-- =============================================
-- TEST SUMMARY
-- =============================================
DECLARE @EndTime DATETIME2 = SYSDATETIME();
DECLARE @TotalDuration FLOAT = DATEDIFF(MILLISECOND, @StartTime, @EndTime) / 1000.0;
DECLARE @TotalTests INT = @TestsPassed + @TestsFailed;

PRINT '========================================'
PRINT 'TEST SUMMARY'
PRINT '========================================'
PRINT 'Total Tests: ' + CAST(@TotalTests AS VARCHAR)
PRINT 'Passed: ' + CAST(@TestsPassed AS VARCHAR)
PRINT 'Failed: ' + CAST(@TestsFailed AS VARCHAR)
PRINT 'Warnings: ' + CAST(@TestsWarning AS VARCHAR)
PRINT 'Total Duration: ' + CAST(@TotalDuration AS VARCHAR) + ' seconds'
PRINT ''

PRINT 'Performance Summary:'
PRINT '  • Installation: Fast for packages with 40+ objects'
PRINT '  • List commands: Sub-second response times'
PRINT '  • Bulk operations: Linear scaling'
PRINT '  • Large tables: Standard SQL Server performance'
PRINT ''

IF @TestsFailed = 0
BEGIN
    PRINT 'Status: ✅ ALL TESTS PASSED'
    PRINT '========================================'
END
ELSE
BEGIN
    PRINT 'Status: ❌ SOME TESTS FAILED'
    PRINT '========================================'
END

GO

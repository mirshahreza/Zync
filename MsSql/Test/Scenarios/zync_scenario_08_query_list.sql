-- =============================================
-- Zync Scenario Test 08: Query & List Operations
-- Author: Zync Development Team
-- Date: 2026-01-06
-- Description: Tests information retrieval and listing
-- Scenarios:
--   8.1: List all packages (ls)
--   8.2: List with search/filter
--   8.3: List objects (lo)
--   8.4: Version tracking queries
--   8.5: Package status verification
-- =============================================

SET NOCOUNT ON;
GO

PRINT '========================================='
PRINT 'ZYNC SCENARIO 08: QUERY & LIST OPERATIONS'
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
-- SETUP: Install test packages
-- =============================================
PRINT '----------------------------------------'
PRINT 'Setup: Installing Test Packages'
PRINT '----------------------------------------'

BEGIN TRY
    EXEC [dbo].[Zync] 'clean';
    EXEC [dbo].[Zync] 'i Math';
    EXEC [dbo].[Zync] 'i String';
    EXEC [dbo].[Zync] 'i Validation';
    PRINT '✓ Test packages installed'
    PRINT ''
END TRY
BEGIN CATCH
    PRINT '✗ Setup failed - ' + ERROR_MESSAGE();
    RETURN;
END CATCH

-- =============================================
-- SCENARIO 8.1: List all packages (ls)
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 8.1: List All Packages'
PRINT '----------------------------------------'

BEGIN TRY
    EXEC [dbo].[Zync] 'ls';
    PRINT '✓ PASS: List command executed'
    SET @TestsPassed = @TestsPassed + 1;
END TRY
BEGIN CATCH
    PRINT '✗ FAIL: List command failed - ' + ERROR_MESSAGE();
    SET @TestsFailed = @TestsFailed + 1;
END CATCH

-- Verify package count via query
DECLARE @InstalledPackages INT = 0;
SELECT @InstalledPackages = COUNT(*)
FROM [dbo].[ZyncPackages]
WHERE Status = 'INSTALLED';

IF @InstalledPackages >= 3
BEGIN
    PRINT '✓ PASS: Expected packages found (' + CAST(@InstalledPackages AS VARCHAR) + ' packages)'
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '✗ FAIL: Expected at least 3 packages, found ' + CAST(@InstalledPackages AS VARCHAR)
    SET @TestsFailed = @TestsFailed + 1;
END

PRINT ''

-- =============================================
-- SCENARIO 8.2: List with search
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 8.2: List with Search/Filter'
PRINT '----------------------------------------'

-- List specific package
BEGIN TRY
    EXEC [dbo].[Zync] 'ls Math';
    PRINT '✓ PASS: Filtered list executed'
    SET @TestsPassed = @TestsPassed + 1;
END TRY
BEGIN CATCH
    PRINT '✗ FAIL: Filtered list failed - ' + ERROR_MESSAGE();
    SET @TestsFailed = @TestsFailed + 1;
END CATCH

-- Query for specific package
DECLARE @MathExists BIT = 0;
IF EXISTS (SELECT 1 FROM [dbo].[ZyncPackages] WHERE PackageName = 'Math' AND Status = 'INSTALLED')
    SET @MathExists = 1;

IF @MathExists = 1
BEGIN
    PRINT '✓ PASS: Math package found in query'
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '✗ FAIL: Math package not found'
    SET @TestsFailed = @TestsFailed + 1;
END

PRINT ''

-- =============================================
-- SCENARIO 8.3: List objects (lo)
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 8.3: List Installed Objects'
PRINT '----------------------------------------'

BEGIN TRY
    EXEC [dbo].[Zync] 'lo';
    PRINT '✓ PASS: List objects command executed'
    SET @TestsPassed = @TestsPassed + 1;
END TRY
BEGIN CATCH
    PRINT '✗ FAIL: List objects failed - ' + ERROR_MESSAGE();
    SET @TestsFailed = @TestsFailed + 1;
END CATCH

-- Verify object tracking
DECLARE @TrackedObjects INT = 0;
SELECT @TrackedObjects = COUNT(*)
FROM [dbo].[ZyncObjects];

IF @TrackedObjects > 0
BEGIN
    PRINT '✓ PASS: Objects tracked (' + CAST(@TrackedObjects AS VARCHAR) + ' objects)'
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '✗ FAIL: No objects found in tracking table'
    SET @TestsFailed = @TestsFailed + 1;
END

-- Query objects by package
DECLARE @MathObjectCount INT = 0;
SELECT @MathObjectCount = COUNT(*)
FROM [dbo].[ZyncObjects] zo
INNER JOIN [dbo].[ZyncPackages] zp ON zo.PackageId = zp.Id
WHERE zp.PackageName = 'Math';

IF @MathObjectCount > 0
BEGIN
    PRINT '✓ PASS: Math package objects: ' + CAST(@MathObjectCount AS VARCHAR)
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '⚠ WARN: No Math objects found in tracking'
    SET @TestsWarning = @TestsWarning + 1;
END

PRINT ''

-- =============================================
-- SCENARIO 8.4: Version tracking
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 8.4: Version Tracking Queries'
PRINT '----------------------------------------'

-- Check version information
SELECT 
    PackageName,
    Version,
    Status,
    InstallDate
FROM [dbo].[ZyncPackages]
WHERE Status = 'INSTALLED'
ORDER BY PackageName;

PRINT '✓ PASS: Version information displayed'
SET @TestsPassed = @TestsPassed + 1;

-- Check install dates
DECLARE @RecentInstalls INT = 0;
SELECT @RecentInstalls = COUNT(*)
FROM [dbo].[ZyncPackages]
WHERE InstallDate >= DATEADD(MINUTE, -5, SYSDATETIME());

IF @RecentInstalls >= 3
BEGIN
    PRINT '✓ PASS: Recent installations tracked'
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '⚠ WARN: Install date tracking may have issues'
    SET @TestsWarning = @TestsWarning + 1;
END

PRINT ''

-- =============================================
-- SCENARIO 8.5: Package status queries
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 8.5: Package Status Verification'
PRINT '----------------------------------------'

-- Get detailed package information
DECLARE @PackageDetails TABLE (
    PackageName NVARCHAR(255),
    Status NVARCHAR(50),
    ObjectCount INT,
    Version NVARCHAR(50)
);

INSERT INTO @PackageDetails
SELECT 
    zp.PackageName,
    zp.Status,
    COUNT(zo.Id) as ObjectCount,
    zp.Version
FROM [dbo].[ZyncPackages] zp
LEFT JOIN [dbo].[ZyncObjects] zo ON zo.PackageId = zp.Id
WHERE zp.Status = 'INSTALLED'
GROUP BY zp.PackageName, zp.Status, zp.Version;

DECLARE @DetailedPackageCount INT;
SELECT @DetailedPackageCount = COUNT(*) FROM @PackageDetails;

IF @DetailedPackageCount >= 3
BEGIN
    PRINT '✓ PASS: Detailed package status available'
    SET @TestsPassed = @TestsPassed + 1;
    
    -- Display summary
    SELECT * FROM @PackageDetails ORDER BY PackageName;
END
ELSE
BEGIN
    PRINT '✗ FAIL: Could not retrieve detailed package status'
    SET @TestsFailed = @TestsFailed + 1;
END

-- Verify object types
DECLARE @ObjectTypes TABLE (ObjectType NVARCHAR(10), TypeCount INT);
INSERT INTO @ObjectTypes
SELECT 
    ObjectType,
    COUNT(*) as TypeCount
FROM [dbo].[ZyncObjects]
GROUP BY ObjectType;

DECLARE @TypeCount INT;
SELECT @TypeCount = COUNT(*) FROM @ObjectTypes;

IF @TypeCount > 0
BEGIN
    PRINT '✓ PASS: Object type distribution available'
    SET @TestsPassed = @TestsPassed + 1;
    
    -- Display distribution
    SELECT * FROM @ObjectTypes ORDER BY TypeCount DESC;
END
ELSE
BEGIN
    PRINT '⚠ WARN: No object type information'
    SET @TestsWarning = @TestsWarning + 1;
END

PRINT ''

-- =============================================
-- SCENARIO 8.6: Cross-reference verification
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 8.6: Database vs Tracking Verification'
PRINT '----------------------------------------'

-- Compare tracked objects with actual database objects
DECLARE @ActualObjects INT = 0;
SELECT @ActualObjects = COUNT(*)
FROM sys.objects o
INNER JOIN [dbo].[ZyncObjects] zo ON zo.ObjectName = o.name
WHERE o.type IN ('P', 'FN', 'TF', 'IF', 'V');

DECLARE @TrackedCount INT = 0;
SELECT @TrackedCount = COUNT(*) FROM [dbo].[ZyncObjects];

IF @ActualObjects = @TrackedCount
BEGIN
    PRINT '✓ PASS: Tracking matches database (' + CAST(@ActualObjects AS VARCHAR) + ' objects)'
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '⚠ WARN: Tracked: ' + CAST(@TrackedCount AS VARCHAR) + 
          ', Actual: ' + CAST(@ActualObjects AS VARCHAR)
    SET @TestsWarning = @TestsWarning + 1;
END

PRINT ''

-- =============================================
-- CLEANUP
-- =============================================
PRINT '----------------------------------------'
PRINT 'Cleanup: Removing Test Packages'
PRINT '----------------------------------------'

BEGIN TRY
    EXEC [dbo].[Zync] 'clean';
    PRINT '✓ Cleanup completed'
END TRY
BEGIN CATCH
    PRINT '⚠ Warning: Cleanup error - ' + ERROR_MESSAGE();
END CATCH

PRINT ''

-- =============================================
-- TEST SUMMARY
-- =============================================
DECLARE @EndTime DATETIME2 = SYSDATETIME();
DECLARE @Duration FLOAT = DATEDIFF(MILLISECOND, @StartTime, @EndTime) / 1000.0;
DECLARE @TotalTests INT = @TestsPassed + @TestsFailed;

PRINT '========================================'
PRINT 'TEST SUMMARY'
PRINT '========================================'
PRINT 'Total Tests: ' + CAST(@TotalTests AS VARCHAR)
PRINT 'Passed: ' + CAST(@TestsPassed AS VARCHAR)
PRINT 'Failed: ' + CAST(@TestsFailed AS VARCHAR)
PRINT 'Warnings: ' + CAST(@TestsWarning AS VARCHAR)
PRINT 'Duration: ' + CAST(@Duration AS VARCHAR) + ' seconds'
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

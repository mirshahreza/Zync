-- =============================================
-- Zync Scenario Test 01: Fresh Installation
-- Author: Zync Development Team
-- Date: 2026-01-06
-- Description: Tests fresh installation scenarios
-- Scenarios:
--   1.1: Verify Zync core is installed
--   1.2: Verify clean state (no packages)
--   1.3: First package installation
--   1.4: Verify package installation
--   1.5: Clean up and verify removal
-- =============================================

SET NOCOUNT ON;
GO

PRINT '========================================='
PRINT 'ZYNC SCENARIO 01: FRESH INSTALLATION'
PRINT '========================================='
PRINT 'Test Date: ' + CONVERT(VARCHAR, GETDATE(), 120)
PRINT ''

DECLARE @TestsPassed INT = 0;
DECLARE @TestsFailed INT = 0;
DECLARE @TestsWarning INT = 0;
DECLARE @StartTime DATETIME2 = SYSDATETIME();

-- =============================================
-- SCENARIO 1.1: Verify Zync core is installed
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 1.1: Verify Zync Core Installation'
PRINT '----------------------------------------'

IF OBJECT_ID('[dbo].[Zync]', 'P') IS NULL
BEGIN
    PRINT '✗ FAIL: Zync procedure not found'
    PRINT '        Please run MsSql/Zync.sql first to install Zync core.'
    PRINT ''
    SET @TestsFailed = @TestsFailed + 1;
    GOTO TestSummary;
END
ELSE
BEGIN
    PRINT '✓ PASS: Zync procedure exists'
    SET @TestsPassed = @TestsPassed + 1;
END

-- Check tracking tables
IF OBJECT_ID('[dbo].[ZyncPackages]', 'U') IS NULL
BEGIN
    PRINT '✗ FAIL: ZyncPackages table not found'
    SET @TestsFailed = @TestsFailed + 1;
    GOTO TestSummary;
END
ELSE
BEGIN
    PRINT '✓ PASS: ZyncPackages tracking table exists'
    SET @TestsPassed = @TestsPassed + 1;
END

IF OBJECT_ID('[dbo].[ZyncObjects]', 'U') IS NULL
BEGIN
    PRINT '✗ FAIL: ZyncObjects table not found'
    SET @TestsFailed = @TestsFailed + 1;
    GOTO TestSummary;
END
ELSE
BEGIN
    PRINT '✓ PASS: ZyncObjects tracking table exists'
    SET @TestsPassed = @TestsPassed + 1;
END

-- Check Ole Automation
DECLARE @OleEnabled INT = 0;
SELECT @OleEnabled = CAST(value_in_use AS INT)
FROM sys.configurations
WHERE name = 'Ole Automation Procedures';

IF @OleEnabled = 0
BEGIN
    PRINT '⚠ WARN: Ole Automation Procedures not enabled'
    PRINT '        Some Zync features may not work. Enable with:'
    PRINT '        EXEC sp_configure ''Ole Automation Procedures'', 1; RECONFIGURE;'
    SET @TestsWarning = @TestsWarning + 1;
END
ELSE
BEGIN
    PRINT '✓ PASS: Ole Automation Procedures enabled'
    SET @TestsPassed = @TestsPassed + 1;
END

PRINT ''

-- =============================================
-- SCENARIO 1.2: Verify clean state
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 1.2: Clean State (No Packages)'
PRINT '----------------------------------------'

-- First clean everything
BEGIN TRY
    EXEC [dbo].[Zync] 'clean';
    PRINT 'Clean command executed successfully'
END TRY
BEGIN CATCH
    PRINT '✗ FAIL: Error during clean - ' + ERROR_MESSAGE();
    SET @TestsFailed = @TestsFailed + 1;
    GOTO TestSummary;
END CATCH

-- Verify all packages removed
DECLARE @PackageCount INT = 0;
SELECT @PackageCount = COUNT(*) 
FROM [dbo].[ZyncPackages] 
WHERE Status IN ('INSTALLED', 'UPDATED');

IF @PackageCount = 0
BEGIN
    PRINT '✓ PASS: No packages installed (clean state verified)'
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '✗ FAIL: Found ' + CAST(@PackageCount AS VARCHAR) + ' packages after clean'
    SET @TestsFailed = @TestsFailed + 1;
END

-- Verify no Zync objects exist (except Zync itself and tracking tables)
DECLARE @ObjectCount INT = 0;
SELECT @ObjectCount = COUNT(*)
FROM sys.objects
WHERE name LIKE 'Zz%' 
  AND name NOT IN ('Zync', 'ZyncPackages', 'ZyncObjects')
  AND type IN ('P', 'FN', 'TF', 'IF', 'V', 'U');

IF @ObjectCount = 0
BEGIN
    PRINT '✓ PASS: No Zync-managed objects found (clean database)'
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '✗ FAIL: Found ' + CAST(@ObjectCount AS VARCHAR) + ' Zync objects after clean'
    SET @TestsFailed = @TestsFailed + 1;
END

PRINT ''

-- =============================================
-- SCENARIO 1.3: First package installation
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 1.3: First Package Installation'
PRINT '----------------------------------------'

-- Install a simple package (Math is a good choice - no dependencies)
BEGIN TRY
    PRINT 'Installing Math package...'
    EXEC [dbo].[Zync] 'i Math';
    PRINT '✓ PASS: Math package installation command executed'
    SET @TestsPassed = @TestsPassed + 1;
END TRY
BEGIN CATCH
    PRINT '✗ FAIL: Error installing Math package - ' + ERROR_MESSAGE();
    SET @TestsFailed = @TestsFailed + 1;
    GOTO TestSummary;
END CATCH

PRINT ''

-- =============================================
-- SCENARIO 1.4: Verify package installation
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 1.4: Verify Package Installation'
PRINT '----------------------------------------'

-- Check package is tracked
DECLARE @MathPackageId INT = NULL;
SELECT @MathPackageId = Id
FROM [dbo].[ZyncPackages]
WHERE PackageName = 'Math' AND Status = 'INSTALLED';

IF @MathPackageId IS NOT NULL
BEGIN
    PRINT '✓ PASS: Math package tracked in ZyncPackages'
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '✗ FAIL: Math package not found in ZyncPackages table'
    SET @TestsFailed = @TestsFailed + 1;
END

-- Check objects are tracked
DECLARE @MathObjectCount INT = 0;
SELECT @MathObjectCount = COUNT(*)
FROM [dbo].[ZyncObjects]
WHERE PackageId = @MathPackageId;

IF @MathObjectCount > 0
BEGIN
    PRINT '✓ PASS: Math objects tracked (' + CAST(@MathObjectCount AS VARCHAR) + ' objects)'
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '✗ FAIL: No Math objects found in ZyncObjects table'
    SET @TestsFailed = @TestsFailed + 1;
END

-- Verify actual objects exist in database
DECLARE @ActualMathObjects INT = 0;
SELECT @ActualMathObjects = COUNT(*)
FROM sys.objects o
INNER JOIN [dbo].[ZyncObjects] zo ON zo.ObjectName = o.name
WHERE zo.PackageId = @MathPackageId
  AND o.type IN ('P', 'FN', 'TF', 'IF', 'V');

IF @ActualMathObjects = @MathObjectCount
BEGIN
    PRINT '✓ PASS: All tracked objects exist in database'
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '✗ FAIL: Mismatch between tracked (' + CAST(@MathObjectCount AS VARCHAR) + 
          ') and actual (' + CAST(@ActualMathObjects AS VARCHAR) + ') objects'
    SET @TestsFailed = @TestsFailed + 1;
END

-- Test a sample Math function to ensure it works
IF OBJECT_ID('[dbo].[ZzAbs]', 'FN') IS NOT NULL
BEGIN
    DECLARE @AbsTest FLOAT = [dbo].[ZzAbs](-42.5);
    IF @AbsTest = 42.5
    BEGIN
        PRINT '✓ PASS: Sample Math function (ZzAbs) works correctly'
        SET @TestsPassed = @TestsPassed + 1;
    END
    ELSE
    BEGIN
        PRINT '✗ FAIL: Sample Math function returned incorrect value'
        SET @TestsFailed = @TestsFailed + 1;
    END
END
ELSE
BEGIN
    PRINT '⚠ WARN: ZzAbs function not found (package may be incomplete)'
    SET @TestsWarning = @TestsWarning + 1;
END

PRINT ''

-- =============================================
-- SCENARIO 1.5: Clean up and verify removal
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 1.5: Clean Up and Verify Removal'
PRINT '----------------------------------------'

-- Remove the package
BEGIN TRY
    EXEC [dbo].[Zync] 'rm Math';
    PRINT '✓ PASS: Math package removal command executed'
    SET @TestsPassed = @TestsPassed + 1;
END TRY
BEGIN CATCH
    PRINT '✗ FAIL: Error removing Math package - ' + ERROR_MESSAGE();
    SET @TestsFailed = @TestsFailed + 1;
    GOTO TestSummary;
END CATCH

-- Verify package removed from tracking
DECLARE @RemainingPackage INT = 0;
SELECT @RemainingPackage = COUNT(*)
FROM [dbo].[ZyncPackages]
WHERE PackageName = 'Math' AND Status = 'INSTALLED';

IF @RemainingPackage = 0
BEGIN
    PRINT '✓ PASS: Math package removed from ZyncPackages'
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '✗ FAIL: Math package still marked as INSTALLED'
    SET @TestsFailed = @TestsFailed + 1;
END

-- Verify objects removed from database
DECLARE @RemainingObjects INT = 0;
SELECT @RemainingObjects = COUNT(*)
FROM sys.objects
WHERE name LIKE 'Zz%'
  AND name NOT IN ('Zync', 'ZyncPackages', 'ZyncObjects')
  AND type IN ('P', 'FN', 'TF', 'IF', 'V', 'U');

IF @RemainingObjects = 0
BEGIN
    PRINT '✓ PASS: All Math objects removed from database'
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '✗ FAIL: Found ' + CAST(@RemainingObjects AS VARCHAR) + ' objects remaining'
    SET @TestsFailed = @TestsFailed + 1;
END

PRINT ''

-- =============================================
-- TEST SUMMARY
-- =============================================
TestSummary:

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

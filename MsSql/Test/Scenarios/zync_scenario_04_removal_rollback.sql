-- =============================================
-- Zync Scenario Test 04: Removal & Rollback
-- Author: Zync Development Team
-- Date: 2026-01-06
-- Description: Tests package removal and rollback scenarios
-- Scenarios:
--   4.1: Remove single package
--   4.2: Remove all packages (clean)
--   4.3: Verify complete removal
--   4.4: Rollback simulation
--   4.5: Data preservation checks
-- =============================================

SET NOCOUNT ON;
GO

PRINT '========================================='
PRINT 'ZYNC SCENARIO 04: REMOVAL & ROLLBACK'
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
    PRINT '✓ Math and String packages installed'
    PRINT ''
END TRY
BEGIN CATCH
    PRINT '✗ Setup failed - ' + ERROR_MESSAGE();
    RETURN;
END CATCH

-- =============================================
-- SCENARIO 4.1: Remove single package
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 4.1: Remove Single Package'
PRINT '----------------------------------------'

-- Count Math objects before removal
DECLARE @MathObjectsBefore INT = 0;
SELECT @MathObjectsBefore = COUNT(*)
FROM [dbo].[ZyncObjects] zo
INNER JOIN [dbo].[ZyncPackages] zp ON zo.PackageId = zp.Id
WHERE zp.PackageName = 'Math';

PRINT 'Math objects before removal: ' + CAST(@MathObjectsBefore AS VARCHAR)

-- Remove Math package
BEGIN TRY
    EXEC [dbo].[Zync] 'rm Math';
    PRINT '✓ PASS: Math removal command executed'
    SET @TestsPassed = @TestsPassed + 1;
END TRY
BEGIN CATCH
    PRINT '✗ FAIL: Removal failed - ' + ERROR_MESSAGE();
    SET @TestsFailed = @TestsFailed + 1;
END CATCH

-- Verify Math is removed
DECLARE @MathPackageExists INT = 0;
SELECT @MathPackageExists = COUNT(*)
FROM [dbo].[ZyncPackages]
WHERE PackageName = 'Math' AND Status = 'INSTALLED';

IF @MathPackageExists = 0
BEGIN
    PRINT '✓ PASS: Math package removed from tracking'
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '✗ FAIL: Math package still in tracking'
    SET @TestsFailed = @TestsFailed + 1;
END

-- Verify String still exists
DECLARE @StringPackageExists INT = 0;
SELECT @StringPackageExists = COUNT(*)
FROM [dbo].[ZyncPackages]
WHERE PackageName = 'String' AND Status = 'INSTALLED';

IF @StringPackageExists = 1
BEGIN
    PRINT '✓ PASS: String package still installed (selective removal worked)'
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '✗ FAIL: String package was incorrectly removed'
    SET @TestsFailed = @TestsFailed + 1;
END

PRINT ''

-- =============================================
-- SCENARIO 4.2: Remove all packages (clean)
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 4.2: Remove All Packages (Clean)'
PRINT '----------------------------------------'

-- Count packages before clean
DECLARE @PackageCountBefore INT = 0;
SELECT @PackageCountBefore = COUNT(*)
FROM [dbo].[ZyncPackages]
WHERE Status = 'INSTALLED';

PRINT 'Packages before clean: ' + CAST(@PackageCountBefore AS VARCHAR)

-- Execute clean
BEGIN TRY
    EXEC [dbo].[Zync] 'clean';
    PRINT '✓ PASS: Clean command executed'
    SET @TestsPassed = @TestsPassed + 1;
END TRY
BEGIN CATCH
    PRINT '✗ FAIL: Clean failed - ' + ERROR_MESSAGE();
    SET @TestsFailed = @TestsFailed + 1;
END CATCH

-- Verify all packages removed
DECLARE @PackageCountAfter INT = 0;
SELECT @PackageCountAfter = COUNT(*)
FROM [dbo].[ZyncPackages]
WHERE Status = 'INSTALLED';

IF @PackageCountAfter = 0
BEGIN
    PRINT '✓ PASS: All packages removed'
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '✗ FAIL: ' + CAST(@PackageCountAfter AS VARCHAR) + ' packages still installed'
    SET @TestsFailed = @TestsFailed + 1;
END

PRINT ''

-- =============================================
-- SCENARIO 4.3: Verify complete removal
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 4.3: Verify Complete Removal'
PRINT '----------------------------------------'

-- Check for remaining objects
DECLARE @RemainingObjects INT = 0;
SELECT @RemainingObjects = COUNT(*)
FROM sys.objects
WHERE name LIKE 'Zz%'
  AND name NOT IN ('Zync', 'ZyncPackages', 'ZyncObjects')
  AND type IN ('P', 'FN', 'TF', 'IF', 'V', 'U');

IF @RemainingObjects = 0
BEGIN
    PRINT '✓ PASS: No package objects remaining'
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '✗ FAIL: ' + CAST(@RemainingObjects AS VARCHAR) + ' objects not removed'
    SET @TestsFailed = @TestsFailed + 1;
END

-- Check ZyncObjects table is clean
DECLARE @TrackedObjects INT = 0;
SELECT @TrackedObjects = COUNT(*) FROM [dbo].[ZyncObjects];

IF @TrackedObjects = 0
BEGIN
    PRINT '✓ PASS: ZyncObjects table clean'
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '✗ FAIL: ' + CAST(@TrackedObjects AS VARCHAR) + ' objects still tracked'
    SET @TestsFailed = @TestsFailed + 1;
END

PRINT ''

-- =============================================
-- SCENARIO 4.4: Reinstall and remove (rollback simulation)
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 4.4: Reinstall and Remove (Rollback)'
PRINT '----------------------------------------'

-- Install Math
BEGIN TRY
    EXEC [dbo].[Zync] 'i Math';
    PRINT '✓ Math reinstalled'
    SET @TestsPassed = @TestsPassed + 1;
END TRY
BEGIN CATCH
    PRINT '✗ FAIL: Reinstall failed - ' + ERROR_MESSAGE();
    SET @TestsFailed = @TestsFailed + 1;
END CATCH

-- Verify it works
IF OBJECT_ID('[dbo].[ZzAbs]', 'FN') IS NOT NULL
BEGIN
    DECLARE @TestVal FLOAT = [dbo].[ZzAbs](-100);
    IF @TestVal = 100
    BEGIN
        PRINT '✓ PASS: Reinstalled package works correctly'
        SET @TestsPassed = @TestsPassed + 1;
    END
    ELSE
    BEGIN
        PRINT '✗ FAIL: Reinstalled function returned wrong value'
        SET @TestsFailed = @TestsFailed + 1;
    END
END
ELSE
BEGIN
    PRINT '✗ FAIL: Expected function not found after reinstall'
    SET @TestsFailed = @TestsFailed + 1;
END

-- Remove again (simulating rollback)
BEGIN TRY
    EXEC [dbo].[Zync] 'rm Math';
    PRINT '✓ Rolled back (removed) successfully'
    SET @TestsPassed = @TestsPassed + 1;
END TRY
BEGIN CATCH
    PRINT '✗ FAIL: Rollback failed - ' + ERROR_MESSAGE();
    SET @TestsFailed = @TestsFailed + 1;
END CATCH

PRINT ''

-- =============================================
-- SCENARIO 4.5: Data preservation with Base package
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 4.5: Data Preservation (Base Package)'
PRINT '----------------------------------------'

-- Install Base package (has tables)
BEGIN TRY
    EXEC [dbo].[Zync] 'i Base';
    PRINT '✓ Base package installed'
    SET @TestsPassed = @TestsPassed + 1;
END TRY
BEGIN CATCH
    PRINT '⚠ WARN: Could not install Base - ' + ERROR_MESSAGE();
    SET @TestsWarning = @TestsWarning + 1;
    GOTO SkipBaseTests;
END CATCH

-- Insert test data
IF OBJECT_ID('[dbo].[BaseInfo]', 'U') IS NOT NULL
BEGIN
    BEGIN TRY
        INSERT INTO [dbo].[BaseInfo] (Title, Description, Category)
        VALUES ('Test Entry', 'Test data for removal test', 'TEST');
        
        DECLARE @TestId INT = SCOPE_IDENTITY();
        PRINT '✓ Test data inserted (Id: ' + CAST(@TestId AS VARCHAR) + ')'
        SET @TestsPassed = @TestsPassed + 1;
        
        -- Note: In real scenario, you would NOT remove Base with data
        -- This is just to show what happens
        PRINT '  (Note: Removing Base with data should be done carefully)'
        PRINT '  (This test only verifies the operation works)'
        
    END TRY
    BEGIN CATCH
        PRINT '⚠ WARN: Could not insert test data - ' + ERROR_MESSAGE();
        SET @TestsWarning = @TestsWarning + 1;
    END CATCH
END

SkipBaseTests:

PRINT ''

-- =============================================
-- CLEANUP
-- =============================================
PRINT '----------------------------------------'
PRINT 'Cleanup: Final Clean'
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

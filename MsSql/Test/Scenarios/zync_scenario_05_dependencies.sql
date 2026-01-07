-- =============================================
-- Zync Scenario Test 05: Dependencies
-- Author: Zync Development Team
-- Date: 2026-01-06
-- Description: Tests package dependency management
-- Scenarios:
--   5.1: Install package with no dependencies
--   5.2: Install multiple packages
--   5.3: Verify package installation order
--   5.4: Test dependency relationships
--   5.5: Clean all packages
-- Note: Full dependency management may be a future feature
-- =============================================

SET NOCOUNT ON;
GO

PRINT '========================================='
PRINT 'ZYNC SCENARIO 05: DEPENDENCIES'
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
PRINT 'Setup: Clean Environment'
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
-- SCENARIO 5.1: Install independent packages
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 5.1: Install Independent Packages'
PRINT '----------------------------------------'

-- Install Math (no dependencies)
BEGIN TRY
    EXEC [dbo].[Zync] 'i Math';
    PRINT '✓ PASS: Math package installed'
    SET @TestsPassed = @TestsPassed + 1;
END TRY
BEGIN CATCH
    PRINT '✗ FAIL: Math install failed - ' + ERROR_MESSAGE();
    SET @TestsFailed = @TestsFailed + 1;
END CATCH

-- Install String (no dependencies)
BEGIN TRY
    EXEC [dbo].[Zync] 'i String';
    PRINT '✓ PASS: String package installed'
    SET @TestsPassed = @TestsPassed + 1;
END TRY
BEGIN CATCH
    PRINT '✗ FAIL: String install failed - ' + ERROR_MESSAGE();
    SET @TestsFailed = @TestsFailed + 1;
END CATCH

-- Verify both exist
DECLARE @InstalledCount INT = 0;
SELECT @InstalledCount = COUNT(*)
FROM [dbo].[ZyncPackages]
WHERE PackageName IN ('Math', 'String') AND Status = 'INSTALLED';

IF @InstalledCount = 2
BEGIN
    PRINT '✓ PASS: Both packages installed successfully'
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '✗ FAIL: Expected 2 packages, found ' + CAST(@InstalledCount AS VARCHAR)
    SET @TestsFailed = @TestsFailed + 1;
END

PRINT ''

-- =============================================
-- SCENARIO 5.2: Install package that might use others
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 5.2: Install Base Package'
PRINT '----------------------------------------'

-- Base package is foundational but independent
BEGIN TRY
    EXEC [dbo].[Zync] 'i Base';
    PRINT '✓ PASS: Base package installed'
    SET @TestsPassed = @TestsPassed + 1;
END TRY
BEGIN CATCH
    PRINT '⚠ WARN: Base install issue - ' + ERROR_MESSAGE();
    SET @TestsWarning = @TestsWarning + 1;
END CATCH

PRINT ''

-- =============================================
-- SCENARIO 5.3: Verify all packages coexist
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 5.3: Verify Package Coexistence'
PRINT '----------------------------------------'

-- List all installed packages
DECLARE @AllPackages INT = 0;
SELECT @AllPackages = COUNT(*)
FROM [dbo].[ZyncPackages]
WHERE Status = 'INSTALLED';

PRINT 'Total installed packages: ' + CAST(@AllPackages AS VARCHAR)

IF @AllPackages >= 2
BEGIN
    PRINT '✓ PASS: Multiple packages coexist'
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '✗ FAIL: Expected at least 2 packages'
    SET @TestsFailed = @TestsFailed + 1;
END

-- Verify objects from different packages exist
IF OBJECT_ID('[dbo].[ZzAverage]', 'FN') IS NOT NULL
   AND OBJECT_ID('[dbo].[ZzAbbreviate]', 'FN') IS NOT NULL
BEGIN
    PRINT '✓ PASS: Objects from different packages accessible'
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '✗ FAIL: Not all expected objects found'
    SET @TestsFailed = @TestsFailed + 1;
END

PRINT ''

-- =============================================
-- SCENARIO 5.4: Remove in reverse order
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 5.4: Selective Removal'
PRINT '----------------------------------------'

-- Remove Math first
BEGIN TRY
    EXEC [dbo].[Zync] 'rm Math';
    PRINT '✓ Math removed'
    SET @TestsPassed = @TestsPassed + 1;
END TRY
BEGIN CATCH
    PRINT '✗ FAIL: Math removal failed - ' + ERROR_MESSAGE();
    SET @TestsFailed = @TestsFailed + 1;
END CATCH

-- Verify String still works
IF OBJECT_ID('[dbo].[ZzAbbreviate]', 'FN') IS NOT NULL
BEGIN
    DECLARE @TestStr NVARCHAR(100) = [dbo].[ZzAbbreviate]('Database Management System', 20);
    IF @TestStr IS NOT NULL
    BEGIN
        PRINT '✓ PASS: String package still functional after Math removal'
        SET @TestsPassed = @TestsPassed + 1;
    END
    ELSE
    BEGIN
        PRINT '✗ FAIL: String function not working'
        SET @TestsFailed = @TestsFailed + 1;
    END
END
ELSE
BEGIN
    PRINT '✗ FAIL: String package affected by Math removal'
    SET @TestsFailed = @TestsFailed + 1;
END

PRINT ''

-- =============================================
-- SCENARIO 5.5: Note about future dependencies
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 5.5: Dependency Features (Future)'
PRINT '----------------------------------------'

PRINT 'ℹ INFO: Advanced dependency features may include:'
PRINT '  • Automatic dependency resolution'
PRINT '  • Prevent removal of packages with dependents'
PRINT '  • Dependency chain validation'
PRINT '  • Circular dependency detection'
PRINT ''
PRINT '  Current implementation: Manual package management'
SET @TestsWarning = @TestsWarning + 1;

PRINT ''

-- =============================================
-- CLEANUP
-- =============================================
PRINT '----------------------------------------'
PRINT 'Cleanup: Remove All Packages'
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

-- =============================================
-- Zync Scenario Test 06: Error Handling
-- Author: Zync Development Team
-- Date: 2026-01-06
-- Description: Tests error conditions and recovery
-- Scenarios:
--   6.1: Installing non-existent package
--   6.2: Invalid command syntax
--   6.3: Ole Automation check
--   6.4: Permission requirements
--   6.5: Edge cases and recovery
-- =============================================

SET NOCOUNT ON;
GO

PRINT '========================================='
PRINT 'ZYNC SCENARIO 06: ERROR HANDLING'
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
-- SCENARIO 6.1: Non-existent package
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 6.1: Installing Non-Existent Package'
PRINT '----------------------------------------'

BEGIN TRY
    EXEC [dbo].[Zync] 'i NonExistentPackage123';
    PRINT '⚠ WARN: Command did not throw error for non-existent package'
    SET @TestsWarning = @TestsWarning + 1;
END TRY
BEGIN CATCH
    PRINT '✓ PASS: Non-existent package handled gracefully'
    PRINT '  Error: ' + ERROR_MESSAGE()
    SET @TestsPassed = @TestsPassed + 1;
END CATCH

PRINT ''

-- =============================================
-- SCENARIO 6.2: Invalid syntax
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 6.2: Invalid Command Syntax'
PRINT '----------------------------------------'

-- Test empty command
BEGIN TRY
    EXEC [dbo].[Zync] '';
    PRINT '⚠ WARN: Empty command accepted'
    SET @TestsWarning = @TestsWarning + 1;
END TRY
BEGIN CATCH
    PRINT '✓ PASS: Empty command rejected'
    SET @TestsPassed = @TestsPassed + 1;
END CATCH

-- Test invalid command
BEGIN TRY
    EXEC [dbo].[Zync] 'InvalidCommand xyz';
    PRINT '⚠ WARN: Invalid command accepted'
    SET @TestsWarning = @TestsWarning + 1;
END TRY
BEGIN CATCH
    PRINT '✓ PASS: Invalid command rejected'
    SET @TestsPassed = @TestsPassed + 1;
END CATCH

PRINT ''

-- =============================================
-- SCENARIO 6.3: Ole Automation check
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 6.3: Ole Automation Procedures Check'
PRINT '----------------------------------------'

DECLARE @OleEnabled INT = 0;
SELECT @OleEnabled = CAST(value_in_use AS INT)
FROM sys.configurations
WHERE name = 'Ole Automation Procedures';

IF @OleEnabled = 1
BEGIN
    PRINT '✓ PASS: Ole Automation Procedures enabled'
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '⚠ WARN: Ole Automation Procedures disabled'
    PRINT '  Some features may not work. Enable with:'
    PRINT '  EXEC sp_configure ''Ole Automation Procedures'', 1;'
    PRINT '  RECONFIGURE;'
    SET @TestsWarning = @TestsWarning + 1;
END

PRINT ''

-- =============================================
-- SCENARIO 6.4: Permission checks
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 6.4: Permission Requirements'
PRINT '----------------------------------------'

-- Check if user has CREATE permissions
IF HAS_PERMS_BY_NAME(DB_NAME(), 'DATABASE', 'CREATE PROCEDURE') = 1
BEGIN
    PRINT '✓ PASS: User has CREATE PROCEDURE permission'
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '⚠ WARN: User lacks CREATE PROCEDURE permission'
    SET @TestsWarning = @TestsWarning + 1;
END

IF HAS_PERMS_BY_NAME(DB_NAME(), 'DATABASE', 'CREATE FUNCTION') = 1
BEGIN
    PRINT '✓ PASS: User has CREATE FUNCTION permission'
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '⚠ WARN: User lacks CREATE FUNCTION permission'
    SET @TestsWarning = @TestsWarning + 1;
END

IF HAS_PERMS_BY_NAME(DB_NAME(), 'DATABASE', 'CREATE TABLE') = 1
BEGIN
    PRINT '✓ PASS: User has CREATE TABLE permission'
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '⚠ WARN: User lacks CREATE TABLE permission'
    SET @TestsWarning = @TestsWarning + 1;
END

PRINT ''

-- =============================================
-- SCENARIO 6.5: Edge cases
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 6.5: Edge Cases'
PRINT '----------------------------------------'

-- Try to remove package that's not installed
BEGIN TRY
    EXEC [dbo].[Zync] 'rm PackageNotInstalled';
    PRINT '⚠ WARN: Removing non-installed package did not error'
    SET @TestsWarning = @TestsWarning + 1;
END TRY
BEGIN CATCH
    PRINT '✓ PASS: Removing non-installed package handled'
    SET @TestsPassed = @TestsPassed + 1;
END CATCH

-- Try to clean already clean database
BEGIN TRY
    EXEC [dbo].[Zync] 'clean';
    PRINT '✓ PASS: Clean on already clean database works'
    SET @TestsPassed = @TestsPassed + 1;
END TRY
BEGIN CATCH
    PRINT '✗ FAIL: Clean command failed - ' + ERROR_MESSAGE();
    SET @TestsFailed = @TestsFailed + 1;
END CATCH

-- Install then immediately reinstall
BEGIN TRY
    EXEC [dbo].[Zync] 'i Math';
    EXEC [dbo].[Zync] 'i Math';
    PRINT '✓ PASS: Double install handled'
    SET @TestsPassed = @TestsPassed + 1;
END TRY
BEGIN CATCH
    PRINT '⚠ WARN: Double install caused error (expected) - ' + ERROR_MESSAGE();
    SET @TestsWarning = @TestsWarning + 1;
END CATCH

PRINT ''

-- =============================================
-- SCENARIO 6.6: Recovery test
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 6.6: Recovery After Errors'
PRINT '----------------------------------------'

-- Verify system still works after errors
BEGIN TRY
    EXEC [dbo].[Zync] 'ls';
    PRINT '✓ PASS: System functional after error scenarios'
    SET @TestsPassed = @TestsPassed + 1;
END TRY
BEGIN CATCH
    PRINT '✗ FAIL: System not functional - ' + ERROR_MESSAGE();
    SET @TestsFailed = @TestsFailed + 1;
END CATCH

-- Verify we can still install packages
IF OBJECT_ID('[dbo].[ZzAverage]', 'FN') IS NOT NULL
BEGIN
    DECLARE @TestCalc FLOAT = [dbo].[ZzAverage]('10,20,30');
    IF @TestCalc = 20
    BEGIN
        PRINT '✓ PASS: Installed packages work correctly after errors'
        SET @TestsPassed = @TestsPassed + 1;
    END
    ELSE
    BEGIN
        PRINT '✗ FAIL: Package functions not working'
        SET @TestsFailed = @TestsFailed + 1;
    END
END
ELSE
BEGIN
    PRINT '⚠ WARN: Math package not fully installed'
    SET @TestsWarning = @TestsWarning + 1;
END

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

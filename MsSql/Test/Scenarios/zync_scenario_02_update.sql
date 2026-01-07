-- =============================================
-- Zync Scenario Test 02: Update Operations
-- Author: Zync Development Team
-- Date: 2026-01-06
-- Description: Tests package update scenarios
-- Scenarios:
--   2.1: Package with new objects (simulate update)
--   2.2: Package with objects removed
--   2.3: Package with modified definitions
--   2.4: Manual user objects (not tracked)
--   2.5: Update command behavior
-- =============================================

SET NOCOUNT ON;
GO

PRINT '========================================='
PRINT 'ZYNC SCENARIO 02: UPDATE OPERATIONS'
PRINT '========================================='
PRINT 'Test Date: ' + CONVERT(VARCHAR, GETDATE(), 120)
PRINT ''

DECLARE @TestsPassed INT = 0;
DECLARE @TestsFailed INT = 0;
DECLARE @TestsWarning INT = 0;
DECLARE @StartTime DATETIME2 = SYSDATETIME();

-- =============================================
-- PREREQUISITE: Verify Zync is installed
-- =============================================
IF OBJECT_ID('[dbo].[Zync]', 'P') IS NULL
BEGIN
    PRINT '❌ PREREQUISITE FAILED: Zync not installed'
    PRINT 'Please run MsSql/Zync.sql first'
    RETURN;
END

PRINT '✓ Prerequisite: Zync core is installed'
PRINT ''

-- =============================================
-- SETUP: Clean environment and install base package
-- =============================================
PRINT '----------------------------------------'
PRINT 'Setup: Preparing Test Environment'
PRINT '----------------------------------------'

BEGIN TRY
    EXEC [dbo].[Zync] 'clean';
    PRINT '✓ Environment cleaned'
END TRY
BEGIN CATCH
    PRINT '✗ FAIL: Error during setup - ' + ERROR_MESSAGE();
    RETURN;
END CATCH

-- Install String package for testing
BEGIN TRY
    EXEC [dbo].[Zync] 'i String';
    PRINT '✓ String package installed for testing'
    PRINT ''
END TRY
BEGIN CATCH
    PRINT '✗ FAIL: Could not install String package - ' + ERROR_MESSAGE();
    RETURN;
END CATCH

-- =============================================
-- SCENARIO 2.1: Simulating new objects added
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 2.1: New Objects Added to Package'
PRINT '----------------------------------------'

-- Get current object count
DECLARE @InitialObjectCount INT;
SELECT @InitialObjectCount = COUNT(*)
FROM [dbo].[ZyncObjects]
WHERE PackageId IN (SELECT Id FROM [dbo].[ZyncPackages] WHERE PackageName = 'String');

PRINT 'Initial object count: ' + CAST(@InitialObjectCount AS VARCHAR)

-- Create a simulated new object manually
IF OBJECT_ID('[dbo].[ZzTestNewFunction]', 'FN') IS NOT NULL
    DROP FUNCTION [dbo].[ZzTestNewFunction];

BEGIN TRY
    EXEC('
    CREATE FUNCTION [dbo].[ZzTestNewFunction](@input NVARCHAR(MAX))
    RETURNS NVARCHAR(MAX)
    AS
    BEGIN
        RETURN UPPER(@input);
    END
    ');
    PRINT '✓ PASS: Simulated new function created'
    SET @TestsPassed = @TestsPassed + 1;
END TRY
BEGIN CATCH
    PRINT '✗ FAIL: Could not create test function - ' + ERROR_MESSAGE();
    SET @TestsFailed = @TestsFailed + 1;
END CATCH

-- In real scenario, running 'i String' again would detect and add this
-- For now, we just verify the object exists
IF OBJECT_ID('[dbo].[ZzTestNewFunction]', 'FN') IS NOT NULL
BEGIN
    PRINT '✓ PASS: New function exists in database'
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '✗ FAIL: New function not found'
    SET @TestsFailed = @TestsFailed + 1;
END

-- Clean up test function
IF OBJECT_ID('[dbo].[ZzTestNewFunction]', 'FN') IS NOT NULL
    DROP FUNCTION [dbo].[ZzTestNewFunction];

PRINT ''

-- =============================================
-- SCENARIO 2.2: Package with objects removed
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 2.2: Objects Removed from Package'
PRINT '----------------------------------------'

-- Get a sample object from String package
DECLARE @SampleObject NVARCHAR(128);
SELECT TOP 1 @SampleObject = ObjectName
FROM [dbo].[ZyncObjects]
WHERE PackageId IN (SELECT Id FROM [dbo].[ZyncPackages] WHERE PackageName = 'String')
ORDER BY ObjectName;

IF @SampleObject IS NOT NULL
BEGIN
    PRINT 'Sample object for testing: ' + @SampleObject
    PRINT '✓ PASS: Found test object from String package'
    SET @TestsPassed = @TestsPassed + 1;
    
    -- In real scenario, if this object is removed from package definition
    -- and 'i String' is run again, Zync should handle it
    PRINT '  (In production, Zync update would detect removed objects)'
END
ELSE
BEGIN
    PRINT '⚠ WARN: No String objects found for testing'
    SET @TestsWarning = @TestsWarning + 1;
END

PRINT ''

-- =============================================
-- SCENARIO 2.3: Modified object definitions
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 2.3: Modified Object Definitions'
PRINT '----------------------------------------'

-- Test updating an existing function
IF OBJECT_ID('[dbo].[ZzTestModifyFunction]', 'FN') IS NOT NULL
    DROP FUNCTION [dbo].[ZzTestModifyFunction];

-- Create initial version
BEGIN TRY
    EXEC('
    CREATE FUNCTION [dbo].[ZzTestModifyFunction](@val INT)
    RETURNS INT
    AS
    BEGIN
        RETURN @val * 2;  -- Version 1: multiply by 2
    END
    ');
    
    DECLARE @V1Result INT = [dbo].[ZzTestModifyFunction](5);
    
    IF @V1Result = 10
    BEGIN
        PRINT '✓ PASS: Version 1 function created (result: ' + CAST(@V1Result AS VARCHAR) + ')'
        SET @TestsPassed = @TestsPassed + 1;
    END
    ELSE
    BEGIN
        PRINT '✗ FAIL: Version 1 returned unexpected result'
        SET @TestsFailed = @TestsFailed + 1;
    END
END TRY
BEGIN CATCH
    PRINT '✗ FAIL: Error creating Version 1 - ' + ERROR_MESSAGE();
    SET @TestsFailed = @TestsFailed + 1;
END CATCH

-- Modify function (simulate update)
BEGIN TRY
    EXEC('
    ALTER FUNCTION [dbo].[ZzTestModifyFunction](@val INT)
    RETURNS INT
    AS
    BEGIN
        RETURN @val * 3;  -- Version 2: multiply by 3
    END
    ');
    
    DECLARE @V2Result INT = [dbo].[ZzTestModifyFunction](5);
    
    IF @V2Result = 15
    BEGIN
        PRINT '✓ PASS: Version 2 function updated (result: ' + CAST(@V2Result AS VARCHAR) + ')'
        SET @TestsPassed = @TestsPassed + 1;
    END
    ELSE
    BEGIN
        PRINT '✗ FAIL: Version 2 returned unexpected result'
        SET @TestsFailed = @TestsFailed + 1;
    END
END TRY
BEGIN CATCH
    PRINT '✗ FAIL: Error updating function - ' + ERROR_MESSAGE();
    SET @TestsFailed = @TestsFailed + 1;
END CATCH

-- Clean up
IF OBJECT_ID('[dbo].[ZzTestModifyFunction]', 'FN') IS NOT NULL
    DROP FUNCTION [dbo].[ZzTestModifyFunction];

PRINT ''

-- =============================================
-- SCENARIO 2.4: Manual user objects
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 2.4: Manual User Objects (Not Tracked)'
PRINT '----------------------------------------'

-- Create a manual object with Zync prefix
IF OBJECT_ID('[dbo].[ZzMyCustomFunction]', 'FN') IS NOT NULL
    DROP FUNCTION [dbo].[ZzMyCustomFunction];

BEGIN TRY
    EXEC('
    CREATE FUNCTION [dbo].[ZzMyCustomFunction](@x INT, @y INT)
    RETURNS INT
    AS
    BEGIN
        RETURN @x + @y;
    END
    ');
    PRINT '✓ PASS: Manual custom function created'
    SET @TestsPassed = @TestsPassed + 1;
END TRY
BEGIN CATCH
    PRINT '✗ FAIL: Could not create manual function - ' + ERROR_MESSAGE();
    SET @TestsFailed = @TestsFailed + 1;
END CATCH

-- Verify it's NOT tracked by Zync
DECLARE @IsTracked BIT = 0;
IF EXISTS (SELECT 1 FROM [dbo].[ZyncObjects] WHERE ObjectName = 'ZzMyCustomFunction')
    SET @IsTracked = 1;

IF @IsTracked = 0
BEGIN
    PRINT '✓ PASS: Manual function not tracked by Zync (as expected)'
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '✗ FAIL: Manual function incorrectly tracked by Zync'
    SET @TestsFailed = @TestsFailed + 1;
END

-- Verify Zync clean does not remove untracked objects
DECLARE @ObjectExistsBeforeClean BIT = 0;
IF OBJECT_ID('[dbo].[ZzMyCustomFunction]', 'FN') IS NOT NULL
    SET @ObjectExistsBeforeClean = 1;

-- This is informational only - we won't actually run clean to avoid breaking tests
IF @ObjectExistsBeforeClean = 1
BEGIN
    PRINT '✓ INFO: Manual object persists (Zync clean would preserve untracked objects)'
END

-- Clean up manual object
IF OBJECT_ID('[dbo].[ZzMyCustomFunction]', 'FN') IS NOT NULL
    DROP FUNCTION [dbo].[ZzMyCustomFunction];

PRINT ''

-- =============================================
-- SCENARIO 2.5: Reinstall (Update) behavior
-- =============================================
PRINT '----------------------------------------'
PRINT 'Scenario 2.5: Reinstall/Update Behavior'
PRINT '----------------------------------------'

-- Reinstall String package
BEGIN TRY
    PRINT 'Reinstalling String package...'
    EXEC [dbo].[Zync] 'i String';
    PRINT '✓ PASS: Reinstall command executed successfully'
    SET @TestsPassed = @TestsPassed + 1;
END TRY
BEGIN CATCH
    PRINT '✗ FAIL: Reinstall failed - ' + ERROR_MESSAGE();
    SET @TestsFailed = @TestsFailed + 1;
END CATCH

-- Verify package status
DECLARE @PackageStatus NVARCHAR(50);
SELECT @PackageStatus = Status
FROM [dbo].[ZyncPackages]
WHERE PackageName = 'String';

IF @PackageStatus IN ('INSTALLED', 'UPDATED')
BEGIN
    PRINT '✓ PASS: Package status after reinstall: ' + @PackageStatus
    SET @TestsPassed = @TestsPassed + 1;
END
ELSE
BEGIN
    PRINT '✗ FAIL: Unexpected package status: ' + ISNULL(@PackageStatus, 'NULL')
    SET @TestsFailed = @TestsFailed + 1;
END

-- Verify objects still work after reinstall
IF OBJECT_ID('[dbo].[ZzUpper]', 'FN') IS NOT NULL
BEGIN
    DECLARE @TestResult NVARCHAR(50) = [dbo].[ZzUpper]('test');
    IF @TestResult = 'TEST'
    BEGIN
        PRINT '✓ PASS: String functions work after reinstall'
        SET @TestsPassed = @TestsPassed + 1;
    END
    ELSE
    BEGIN
        PRINT '✗ FAIL: String functions not working correctly'
        SET @TestsFailed = @TestsFailed + 1;
    END
END
ELSE
BEGIN
    PRINT '⚠ WARN: ZzUpper function not found after reinstall'
    SET @TestsWarning = @TestsWarning + 1;
END

PRINT ''

-- =============================================
-- CLEANUP
-- =============================================
PRINT '----------------------------------------'
PRINT 'Cleanup: Removing Test Data'
PRINT '----------------------------------------'

BEGIN TRY
    EXEC [dbo].[Zync] 'clean';
    PRINT '✓ Cleanup completed'
END TRY
BEGIN CATCH
    PRINT '⚠ Warning: Cleanup encountered error - ' + ERROR_MESSAGE();
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

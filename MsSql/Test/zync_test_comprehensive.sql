-- =============================================
-- Author:		GitHub Copilot
-- Create date: 2025-09-27
-- Description:	Comprehensive test for Zync package manager.
-- This test will:
-- 1. Clean the environment.
-- 2. Install a package (e.g., DbMan).
-- 3. List installed objects to verify installation.
-- 4. Install another package (e.g., DateTime).
-- 5. Remove a package.
-- 6. Verify removal.
-- 7. End with a final cleanup.
-- =============================================

PRINT 'Starting comprehensive test for Zync...';
PRINT '=========================================';

IF OBJECT_ID('[dbo].[Zync]', 'P') IS NULL
BEGIN
    PRINT 'Zync is not installed in this database. Please run MsSql/Zync.sql first.';
    RETURN;
END

-- Enable OLE Automation if not enabled
PRINT 'Step 0: Ensuring OLE Automation is enabled...';
BEGIN TRY
    EXEC sp_configure 'show advanced options', 1;
    RECONFIGURE;
    EXEC sp_configure 'Ole Automation Procedures', 1;
    RECONFIGURE;
    PRINT '-> OLE Automation Procedures enabled.';
END TRY
BEGIN CATCH
    PRINT 'Warning: Could not configure OLE Automation. Please ensure it is enabled.';
END CATCH
PRINT '=========================================';


-- Step 1: Initial Cleanup
PRINT 'Step 1: Cleaning all Zync-managed objects for a fresh start...';
EXEC [dbo].[Zync] 'clean';
PRINT '-> Cleanup complete.';
PRINT '=========================================';

-- Step 2: Install the DbMan package
PRINT 'Step 2: Installing the "DbMan" package...';
EXEC [dbo].[Zync] 'i DbMan';
PRINT '-> "DbMan" package installation command executed.';
PRINT '=========================================';

-- Step 3: Verify DbMan installation by listing objects
PRINT 'Step 3: Listing Zync-managed objects to verify installation...';
EXEC [dbo].[Zync] 'lo';
PRINT '-> Object listing complete. Check for DbMan objects (e.g., ZzAlterColumn).';
PRINT '=========================================';

-- Step 4: Install the DateTime package
PRINT 'Step 4: Installing the "DateTime" package...';
EXEC [dbo].[Zync] 'i DateTime';
PRINT '-> "DateTime" package installation command executed.';
PRINT '=========================================';

-- Step 5: Verify DateTime installation by listing objects
PRINT 'Step 5: Listing Zync-managed objects again to verify "DateTime" installation...';
EXEC [dbo].[Zync] 'lo';
PRINT '-> Object listing complete. Check for DateTime objects (e.g., ZzAge).';
PRINT '=========================================';

-- Step 6: Remove the DbMan package
PRINT 'Step 6: Removing the "DbMan" package...';
EXEC [dbo].[Zync] 'rm DbMan';
PRINT '-> "DbMan" package removal command executed.';
PRINT '=========================================';

-- Step 7: Verify DbMan removal
PRINT 'Step 7: Listing objects to verify "DbMan" package removal...';
EXEC [dbo].[Zync] 'lo';
PRINT '-> Object listing complete. DbMan objects should be gone.';
PRINT '=========================================';

-- Step 8: Final Cleanup
PRINT 'Step 8: Performing final cleanup to leave the database clean...';
EXEC [dbo].[Zync] 'clean';
PRINT '-> Final cleanup complete.';
PRINT '=========================================';

PRINT 'Comprehensive test finished.';

GO

-- Optional: quick smoke check of newly added utilities if present
PRINT 'Optional smoke checks for new utilities...';
IF OBJECT_ID('[dbo].[ZzSelectWaitStats]', 'V') IS NOT NULL SELECT TOP 1 * FROM [dbo].[ZzSelectWaitStats];
IF OBJECT_ID('[dbo].[ZzSelectTempdbUsage]', 'V') IS NOT NULL SELECT TOP 1 * FROM [dbo].[ZzSelectTempdbUsage];
IF OBJECT_ID('[dbo].[ZzSelectFileStats]', 'V') IS NOT NULL SELECT TOP 1 * FROM [dbo].[ZzSelectFileStats];
IF OBJECT_ID('[dbo].[ZzISOWeekNumber]', 'FN') IS NOT NULL SELECT [dbo].[ZzISOWeekNumber](GETDATE()) AS ISOWeekNumber;
PRINT 'Smoke checks completed.';

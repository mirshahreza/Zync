-- =============================================
-- Test: Zync Auto-Update Mechanism
-- Description: Tests the automatic update checking and Ole Automation enabling
-- =============================================

PRINT '========================================='
PRINT 'ZYNC AUTO-UPDATE TEST'
PRINT '========================================='
PRINT ''

-- Step 1: Check current Zync version
PRINT '1. Checking current Zync version...'
IF OBJECT_ID('[dbo].[Zync]', 'P') IS NOT NULL
BEGIN
    -- Check if ZYNC_CORE record exists
    IF EXISTS (SELECT 1 FROM [dbo].[ZyncPackages] WHERE PackageName = 'ZYNC_CORE')
    BEGIN
        SELECT 
            PackageName,
            Version,
            CAST(Version / 100.0 AS DECIMAL(5,2)) AS VersionNumber,
            Status,
            InstallDate
        FROM [dbo].[ZyncPackages]
        WHERE PackageName = 'ZYNC_CORE';
    END
    ELSE
    BEGIN
        PRINT '   No ZYNC_CORE record found (first run).'
    END
END
ELSE
BEGIN
    PRINT '   ERROR: Zync procedure not found!'
    RETURN
END
PRINT ''

-- Step 2: Check Ole Automation status
PRINT '2. Checking Ole Automation Procedures status...'
SELECT 
    name,
    value AS CurrentValue,
    value_in_use AS ValueInUse,
    CASE WHEN value = 1 THEN 'ENABLED' ELSE 'DISABLED' END AS Status
FROM sys.configurations
WHERE name = 'Ole Automation Procedures';
PRINT ''

-- Step 3: Clear session context to force update check
PRINT '3. Clearing session context to force update check...'
EXEC sp_set_session_context @key = N'ZyncAutoUpdateChecked', @value = NULL;
PRINT '   Session context cleared.'
PRINT ''

-- Step 4: Execute Zync with help command (minimal operation)
PRINT '4. Executing Zync to trigger auto-update check...'
PRINT '========================================='
EXEC [dbo].[Zync] '?';
PRINT '========================================='
PRINT ''

-- Step 5: Verify session context was set
PRINT '5. Verifying session context after execution...'
IF SESSION_CONTEXT(N'ZyncAutoUpdateChecked') IS NOT NULL
    PRINT '   ✓ Session context set correctly (auto-update check completed).'
ELSE
    PRINT '   ✗ Session context NOT set (auto-update check may have failed).'
PRINT ''

-- Step 6: Execute Zync again (should skip update check)
PRINT '6. Executing Zync again (should skip auto-update check)...'
PRINT '========================================='
EXEC [dbo].[Zync] 'ls';
PRINT '========================================='
PRINT ''

-- Step 7: Final status
PRINT '7. Final Zync status...'
IF EXISTS (SELECT 1 FROM [dbo].[ZyncPackages] WHERE PackageName = 'ZYNC_CORE')
BEGIN
    SELECT 
        PackageName,
        CAST(Version / 100.0 AS DECIMAL(5,2)) AS Version,
        Status,
        InstallDate
    FROM [dbo].[ZyncPackages]
    WHERE PackageName = 'ZYNC_CORE';
END
PRINT ''

PRINT '========================================='
PRINT 'AUTO-UPDATE TEST COMPLETED'
PRINT '========================================='

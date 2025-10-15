-- Test rm without package name: should remove all installed packages
PRINT '=== Test: rm (all packages) ==='

-- Pre-clean to start from a known state
BEGIN TRY
    IF OBJECT_ID('[dbo].[Zync]','P') IS NOT NULL EXEC dbo.Zync 'clean'
END TRY
BEGIN CATCH END CATCH

-- Ensure Zync exists
IF OBJECT_ID('[dbo].[Zync]','P') IS NULL
BEGIN
    RAISERROR('Zync procedure not found. Install MsSql/Zync.sql first.',16,1)
    RETURN
END

PRINT 'Installing packages: String, Math'
EXEC dbo.Zync 'i String'
EXEC dbo.Zync 'i Math'

-- Sanity checks after install
DECLARE @HasTrim BIT = CASE WHEN OBJECT_ID('[dbo].[ZzTrim]','FN') IS NOT NULL THEN 1 ELSE 0 END;
DECLARE @HasIsEven BIT = CASE WHEN OBJECT_ID('[dbo].[ZzIsEven]','FN') IS NOT NULL THEN 1 ELSE 0 END;
PRINT 'Post-install existence: ZzTrim=' + CAST(@HasTrim AS VARCHAR(1)) + ', ZzIsEven=' + CAST(@HasIsEven AS VARCHAR(1));

PRINT 'Running: EXEC dbo.Zync ''rm''' 
EXEC dbo.Zync 'rm'

-- Verify removal
DECLARE @StillTrim BIT = CASE WHEN OBJECT_ID('[dbo].[ZzTrim]','FN') IS NOT NULL THEN 1 ELSE 0 END;
DECLARE @StillIsEven BIT = CASE WHEN OBJECT_ID('[dbo].[ZzIsEven]','FN') IS NOT NULL THEN 1 ELSE 0 END;

DECLARE @RemainingTracked INT = (
    SELECT COUNT(*) FROM dbo.ZyncPackages WHERE Status IN ('INSTALLED','UPDATED')
);

IF @StillTrim = 0 AND @StillIsEven = 0 AND @RemainingTracked = 0
    PRINT '✓ PASS: rm (all) removed objects and cleared tracking.'
ELSE
BEGIN
    PRINT '✗ FAIL: rm (all) did not fully remove items.'
    PRINT '  -> ZzTrim exists? ' + CAST(@StillTrim AS VARCHAR(1))
    PRINT '  -> ZzIsEven exists? ' + CAST(@StillIsEven AS VARCHAR(1))
    PRINT '  -> Remaining tracked packages: ' + CAST(@RemainingTracked AS VARCHAR(10))
END

PRINT '=== End Test: rm (all packages) ==='
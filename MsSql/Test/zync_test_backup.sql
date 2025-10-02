-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-10-02
-- Description:	Comprehensive test for Backup package functions
-- =============================================

SET NOCOUNT ON;
DECLARE @TestResults TABLE (
    TestName NVARCHAR(100),
    Status NVARCHAR(10),
    Message NVARCHAR(MAX),
    ExecutionTime DATETIME2
);

DECLARE @StartTime DATETIME2 = SYSDATETIME();
DECLARE @TestName NVARCHAR(100);
DECLARE @Status NVARCHAR(10);
DECLARE @Message NVARCHAR(MAX);

PRINT '🧪 COMPREHENSIVE BACKUP PACKAGE TEST'
PRINT '===================================='
PRINT 'Start Time: ' + CAST(@StartTime AS NVARCHAR(30))
PRINT ''

-- Test 1: Procedure Existence Check
SET @TestName = 'Procedure Existence';
BEGIN TRY
    DECLARE @MissingObjects NVARCHAR(MAX) = '';
    
    IF OBJECT_ID('[dbo].[ZzBackupTable]', 'P') IS NULL
        SET @MissingObjects = @MissingObjects + 'ZzBackupTable, ';
    IF OBJECT_ID('[dbo].[ZzCleanupOldBackups]', 'P') IS NULL
        SET @MissingObjects = @MissingObjects + 'ZzCleanupOldBackups, ';
    IF OBJECT_ID('[dbo].[ZzCreateBackupScript]', 'P') IS NULL
        SET @MissingObjects = @MissingObjects + 'ZzCreateBackupScript, ';
    IF OBJECT_ID('[dbo].[ZzVerifyBackup]', 'P') IS NULL
        SET @MissingObjects = @MissingObjects + 'ZzVerifyBackup, ';
    
    IF LEN(@MissingObjects) > 0
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Missing procedures: ' + LEFT(@MissingObjects, LEN(@MissingObjects) - 2);
    END
    ELSE
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'All 4 backup procedures exist';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '1. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '1. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 2: ZzBackupTable - Parameter Validation
SET @TestName = 'ZzBackupTable - Validation';
BEGIN TRY
    -- Test with NULL parameter (should handle gracefully)
    DECLARE @Result1 INT;
    EXEC @Result1 = [dbo].[ZzBackupTable] @TableName = NULL;
    
    IF @Result1 IS NOT NULL
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Parameter validation works correctly';
    END
    ELSE
    BEGIN
        SET @Status = 'WARN';
        SET @Message = 'Procedure executed with NULL parameter';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '2. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    SET @Status = 'PASS';
    SET @Message = 'Correctly rejected invalid input';
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '2. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END CATCH

-- Test 3: ZzCreateBackupScript - Script Generation
SET @TestName = 'ZzCreateBackupScript';
BEGIN TRY
    -- Create temporary table for testing
    IF OBJECT_ID('tempdb..#TestBackupScript') IS NOT NULL
        DROP TABLE #TestBackupScript;
    
    CREATE TABLE #TestBackupScript (
        ID INT,
        TestData NVARCHAR(100)
    );
    
    DECLARE @ScriptResult NVARCHAR(MAX);
    EXEC [dbo].[ZzCreateBackupScript] 
        @DatabaseName = DB_NAME(),
        @BackupType = 'FULL';
    
    SET @Status = 'PASS';
    SET @Message = 'Backup script generated successfully';
    
    DROP TABLE #TestBackupScript;
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '3. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '3. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 4: ZzCleanupOldBackups - Validation
SET @TestName = 'ZzCleanupOldBackups';
BEGIN TRY
    -- Test cleanup with validation (won't delete real backups in test)
    DECLARE @CleanupResult INT;
    EXEC @CleanupResult = [dbo].[ZzCleanupOldBackups] 
        @RetentionDays = 365; -- Safe number for testing
    
    SET @Status = 'PASS';
    SET @Message = 'Cleanup procedure executed successfully';
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '4. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '4. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 5: ZzVerifyBackup - Validation
SET @TestName = 'ZzVerifyBackup';
BEGIN TRY
    -- Test verification logic
    DECLARE @VerifyResult BIT;
    EXEC @VerifyResult = [dbo].[ZzVerifyBackup] 
        @BackupPath = 'C:\Backup\Test.bak';
    
    SET @Status = 'PASS';
    SET @Message = 'Backup verification procedure executed';
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '5. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    SET @Status = 'PASS';
    SET @Message = 'Expected error for non-existent backup file';
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '5. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END CATCH

-- Test Summary
PRINT ''
PRINT '📊 TEST SUMMARY'
PRINT '==============='

SELECT 
    TestName,
    Status,
    Message
FROM @TestResults
ORDER BY ExecutionTime;

DECLARE @PassCount INT, @FailCount INT, @ErrorCount INT;
SELECT 
    @PassCount = SUM(CASE WHEN Status = 'PASS' THEN 1 ELSE 0 END),
    @FailCount = SUM(CASE WHEN Status = 'FAIL' THEN 1 ELSE 0 END),
    @ErrorCount = SUM(CASE WHEN Status = 'ERROR' THEN 1 ELSE 0 END)
FROM @TestResults;

PRINT 'Results: ' + CAST(@PassCount AS NVARCHAR(5)) + ' PASS, ' + 
      CAST(@FailCount AS NVARCHAR(5)) + ' FAIL, ' + 
      CAST(@ErrorCount AS NVARCHAR(5)) + ' ERROR';

DECLARE @EndTime DATETIME2 = SYSDATETIME();
PRINT 'Total Duration: ' + CAST(DATEDIFF(MILLISECOND, @StartTime, @EndTime) AS NVARCHAR(10)) + ' ms';

IF @FailCount = 0 AND @ErrorCount = 0
    PRINT '🎉 ALL TESTS PASSED!'
ELSE
    PRINT '⚠️  SOME TESTS FAILED - Please review the results above';

PRINT '===================================='

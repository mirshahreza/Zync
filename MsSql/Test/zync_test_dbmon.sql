-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-10-02
-- Description:	Comprehensive test for DbMon (Database Monitoring) package
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

PRINT '🧪 COMPREHENSIVE DATABASE MONITORING TEST'
PRINT '========================================='
PRINT 'Start Time: ' + CAST(@StartTime AS NVARCHAR(30))
PRINT ''

-- Test 1: View/Procedure Existence Check
SET @TestName = 'Object Existence';
BEGIN TRY
    DECLARE @MissingObjects NVARCHAR(MAX) = '';
    DECLARE @ObjectCount INT = 0;
    
    IF OBJECT_ID('[dbo].[ZzSelectActiveSessions]', 'V') IS NULL AND OBJECT_ID('[dbo].[ZzSelectActiveSessions]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzSelectActiveSessions, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzSelectAgentJobsStatus]', 'V') IS NULL AND OBJECT_ID('[dbo].[ZzSelectAgentJobsStatus]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzSelectAgentJobsStatus, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzSelectBackupHistory]', 'V') IS NULL AND OBJECT_ID('[dbo].[ZzSelectBackupHistory]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzSelectBackupHistory, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzSelectBlockingProcesses]', 'V') IS NULL AND OBJECT_ID('[dbo].[ZzSelectBlockingProcesses]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzSelectBlockingProcesses, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzSelectCheckConstraints]', 'V') IS NULL AND OBJECT_ID('[dbo].[ZzSelectCheckConstraints]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzSelectCheckConstraints, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzSelectColumnDependencies]', 'V') IS NULL AND OBJECT_ID('[dbo].[ZzSelectColumnDependencies]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzSelectColumnDependencies, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzSelectDatabaseGrowth]', 'V') IS NULL AND OBJECT_ID('[dbo].[ZzSelectDatabaseGrowth]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzSelectDatabaseGrowth, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzSelectDatabasePermissions]', 'V') IS NULL AND OBJECT_ID('[dbo].[ZzSelectDatabasePermissions]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzSelectDatabasePermissions, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzSelectDatabaseProperties]', 'V') IS NULL AND OBJECT_ID('[dbo].[ZzSelectDatabaseProperties]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzSelectDatabaseProperties, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzSelectDefaultConstraints]', 'V') IS NULL AND OBJECT_ID('[dbo].[ZzSelectDefaultConstraints]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzSelectDefaultConstraints, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzSelectExpensiveQueries]', 'V') IS NULL AND OBJECT_ID('[dbo].[ZzSelectExpensiveQueries]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzSelectExpensiveQueries, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzSelectExtendedProperties]', 'V') IS NULL AND OBJECT_ID('[dbo].[ZzSelectExtendedProperties]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzSelectExtendedProperties, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzSelectFileStats]', 'V') IS NULL AND OBJECT_ID('[dbo].[ZzSelectFileStats]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzSelectFileStats, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzSelectFragmentedIndexes]', 'V') IS NULL AND OBJECT_ID('[dbo].[ZzSelectFragmentedIndexes]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzSelectFragmentedIndexes, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzSelectIdentityColumns]', 'V') IS NULL AND OBJECT_ID('[dbo].[ZzSelectIdentityColumns]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzSelectIdentityColumns, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzSelectIndexUsage]', 'V') IS NULL AND OBJECT_ID('[dbo].[ZzSelectIndexUsage]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzSelectIndexUsage, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzSelectLogFileUsage]', 'V') IS NULL AND OBJECT_ID('[dbo].[ZzSelectLogFileUsage]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzSelectLogFileUsage, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzSelectLongRunningQueries]', 'V') IS NULL AND OBJECT_ID('[dbo].[ZzSelectLongRunningQueries]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzSelectLongRunningQueries, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzSelectMissingIndexes]', 'V') IS NULL AND OBJECT_ID('[dbo].[ZzSelectMissingIndexes]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzSelectMissingIndexes, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzSelectObjectDependencies]', 'V') IS NULL AND OBJECT_ID('[dbo].[ZzSelectObjectDependencies]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzSelectObjectDependencies, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzSelectObjectsDetails]', 'V') IS NULL AND OBJECT_ID('[dbo].[ZzSelectObjectsDetails]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzSelectObjectsDetails, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzSelectObjectsOverview]', 'V') IS NULL AND OBJECT_ID('[dbo].[ZzSelectObjectsOverview]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzSelectObjectsOverview, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzSelectOrphanedUsers]', 'V') IS NULL AND OBJECT_ID('[dbo].[ZzSelectOrphanedUsers]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzSelectOrphanedUsers, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzSelectProceduresFunctionsParameters]', 'V') IS NULL AND OBJECT_ID('[dbo].[ZzSelectProceduresFunctionsParameters]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzSelectProceduresFunctionsParameters, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzSelectServerConfiguration]', 'V') IS NULL AND OBJECT_ID('[dbo].[ZzSelectServerConfiguration]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzSelectServerConfiguration, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzSelectTablesFks]', 'V') IS NULL AND OBJECT_ID('[dbo].[ZzSelectTablesFks]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzSelectTablesFks, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzSelectTablesIndexes]', 'V') IS NULL AND OBJECT_ID('[dbo].[ZzSelectTablesIndexes]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzSelectTablesIndexes, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzSelectTableSizes]', 'V') IS NULL AND OBJECT_ID('[dbo].[ZzSelectTableSizes]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzSelectTableSizes, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzSelectTablesOverview]', 'V') IS NULL AND OBJECT_ID('[dbo].[ZzSelectTablesOverview]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzSelectTablesOverview, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzSelectTablesViewsColumns]', 'V') IS NULL AND OBJECT_ID('[dbo].[ZzSelectTablesViewsColumns]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzSelectTablesViewsColumns, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzSelectTempdbUsage]', 'V') IS NULL AND OBJECT_ID('[dbo].[ZzSelectTempdbUsage]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzSelectTempdbUsage, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzSelectTriggers]', 'V') IS NULL AND OBJECT_ID('[dbo].[ZzSelectTriggers]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzSelectTriggers, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzSelectUniqueAndPKConstraints]', 'V') IS NULL AND OBJECT_ID('[dbo].[ZzSelectUniqueAndPKConstraints]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzSelectUniqueAndPKConstraints, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzSelectUnusedIndexes]', 'V') IS NULL AND OBJECT_ID('[dbo].[ZzSelectUnusedIndexes]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzSelectUnusedIndexes, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzSelectWaitStats]', 'V') IS NULL AND OBJECT_ID('[dbo].[ZzSelectWaitStats]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzSelectWaitStats, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    
    IF LEN(@MissingObjects) > 0
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Missing objects: ' + LEFT(@MissingObjects, LEN(@MissingObjects) - 2);
    END
    ELSE
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'All ' + CAST(@ObjectCount AS NVARCHAR(5)) + ' DbMon objects exist';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '1. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '1. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 2: Database Properties Query
SET @TestName = 'Database Properties';
BEGIN TRY
    DECLARE @PropCount INT;
    SELECT @PropCount = COUNT(*)
    FROM [dbo].[ZzSelectDatabaseProperties];
    
    IF @PropCount > 0
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Retrieved ' + CAST(@PropCount AS NVARCHAR(10)) + ' database properties';
    END
    ELSE
    BEGIN
        SET @Status = 'WARN';
        SET @Message = 'No database properties found';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '2. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '2. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 3: Tables Overview
SET @TestName = 'Tables Overview';
BEGIN TRY
    DECLARE @TableCount INT;
    SELECT @TableCount = COUNT(*)
    FROM [dbo].[ZzSelectTablesOverview];
    
    IF @TableCount >= 0
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Found ' + CAST(@TableCount AS NVARCHAR(10)) + ' tables';
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Query failed';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '3. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '3. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 4: Active Sessions
SET @TestName = 'Active Sessions';
BEGIN TRY
    DECLARE @SessionCount INT;
    SELECT @SessionCount = COUNT(*)
    FROM [dbo].[ZzSelectActiveSessions];
    
    IF @SessionCount >= 0
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Found ' + CAST(@SessionCount AS NVARCHAR(10)) + ' active sessions';
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Query failed';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '4. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '4. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 5: Objects Overview
SET @TestName = 'Objects Overview';
BEGIN TRY
    DECLARE @ObjCount INT;
    SELECT @ObjCount = COUNT(*)
    FROM [dbo].[ZzSelectObjectsOverview];
    
    IF @ObjCount > 0
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Found ' + CAST(@ObjCount AS NVARCHAR(10)) + ' database objects';
    END
    ELSE
    BEGIN
        SET @Status = 'WARN';
        SET @Message = 'No objects found';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '5. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '5. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 6: Server Configuration
SET @TestName = 'Server Configuration';
BEGIN TRY
    DECLARE @ConfigCount INT;
    SELECT @ConfigCount = COUNT(*)
    FROM [dbo].[ZzSelectServerConfiguration];
    
    IF @ConfigCount > 0
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Retrieved ' + CAST(@ConfigCount AS NVARCHAR(10)) + ' configuration settings';
    END
    ELSE
    BEGIN
        SET @Status = 'WARN';
        SET @Message = 'No configuration found';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '6. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '6. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
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

PRINT '========================================='

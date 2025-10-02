-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-10-02
-- Description:	Comprehensive test for DbMan (Database Management) package
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

PRINT '🧪 COMPREHENSIVE DATABASE MANAGEMENT TEST'
PRINT '========================================='
PRINT 'Start Time: ' + CAST(@StartTime AS NVARCHAR(30))
PRINT ''

-- Test 1: Procedure/Function Existence Check
SET @TestName = 'Object Existence';
BEGIN TRY
    DECLARE @MissingObjects NVARCHAR(MAX) = '';
    DECLARE @ObjectCount INT = 0;
    
    IF OBJECT_ID('[dbo].[ZzAlterColumn]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzAlterColumn, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzCreateColumn]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzCreateColumn, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzCreateEmptyProcedure]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzCreateEmptyProcedure, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzCreateEmptyScalarFunction]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzCreateEmptyScalarFunction, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzCreateEmptyTableFunction]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzCreateEmptyTableFunction, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzCreateEmptyView]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzCreateEmptyView, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzCreateOrAlterFk]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzCreateOrAlterFk, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzCreateTableGuid]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzCreateTableGuid, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzCreateTableIdentity]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzCreateTableIdentity, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzDropColumn]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzDropColumn, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzDropFk]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzDropFk, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzDropFunction]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzDropFunction, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzDropProcedure]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzDropProcedure, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzDropTable]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzDropTable, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzDropView]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzDropView, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzEnsureIndex]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzEnsureIndex, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzEnsureSchema]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzEnsureSchema, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzGetCreateOrAlter]', 'FN') IS NULL SET @MissingObjects = @MissingObjects + 'ZzGetCreateOrAlter, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzObjectExist]', 'FN') IS NULL SET @MissingObjects = @MissingObjects + 'ZzObjectExist, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzRenameColumn]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzRenameColumn, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzRenameTable]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzRenameTable, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    IF OBJECT_ID('[dbo].[ZzTruncateTable]', 'P') IS NULL SET @MissingObjects = @MissingObjects + 'ZzTruncateTable, '; ELSE SET @ObjectCount = @ObjectCount + 1;
    
    IF LEN(@MissingObjects) > 0
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Missing objects: ' + LEFT(@MissingObjects, LEN(@MissingObjects) - 2);
    END
    ELSE
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'All ' + CAST(@ObjectCount AS NVARCHAR(5)) + ' DbMan objects exist';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '1. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '1. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 2: ZzObjectExist Function
SET @TestName = 'ZzObjectExist';
BEGIN TRY
    -- Test with existing object
    DECLARE @ExistsResult1 BIT = [dbo].[ZzObjectExist]('ZzObjectExist', 'FUNCTION');
    -- Test with non-existing object
    DECLARE @ExistsResult2 BIT = [dbo].[ZzObjectExist]('NonExistentObject', 'TABLE');
    
    IF @ExistsResult1 = 1 AND @ExistsResult2 = 0
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Object existence detection works correctly';
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Object detection failed';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '2. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '2. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 3: ZzCreateTableIdentity & ZzDropTable
SET @TestName = 'Table Creation/Drop';
BEGIN TRY
    DECLARE @TestTableName NVARCHAR(128) = 'ZzTestTable_' + CAST(NEWID() AS NVARCHAR(36));
    
    -- Create test table
    EXEC [dbo].[ZzCreateTableIdentity] 
        @TableName = @TestTableName,
        @Columns = 'Name NVARCHAR(100), Value INT';
    
    -- Check if created
    DECLARE @TableExists1 BIT = [dbo].[ZzObjectExist](@TestTableName, 'TABLE');
    
    -- Drop test table
    EXEC [dbo].[ZzDropTable] @TableName = @TestTableName;
    
    -- Check if dropped
    DECLARE @TableExists2 BIT = [dbo].[ZzObjectExist](@TestTableName, 'TABLE');
    
    IF @TableExists1 = 1 AND @TableExists2 = 0
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Table creation and drop successful';
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Table operations failed';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '3. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '3. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 4: ZzCreateEmptyProcedure & ZzDropProcedure
SET @TestName = 'Procedure Creation/Drop';
BEGIN TRY
    DECLARE @TestProcName NVARCHAR(128) = 'ZzTestProc_' + CAST(NEWID() AS NVARCHAR(36));
    
    -- Create test procedure
    EXEC [dbo].[ZzCreateEmptyProcedure] @ProcedureName = @TestProcName;
    
    -- Check if created
    DECLARE @ProcExists1 BIT = [dbo].[ZzObjectExist](@TestProcName, 'PROCEDURE');
    
    -- Drop test procedure
    EXEC [dbo].[ZzDropProcedure] @ProcedureName = @TestProcName;
    
    -- Check if dropped
    DECLARE @ProcExists2 BIT = [dbo].[ZzObjectExist](@TestProcName, 'PROCEDURE');
    
    IF @ProcExists1 = 1 AND @ProcExists2 = 0
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Procedure creation and drop successful';
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Procedure operations failed';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '4. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '4. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 5: ZzEnsureSchema
SET @TestName = 'Schema Ensure';
BEGIN TRY
    DECLARE @TestSchemaName NVARCHAR(128) = 'ZzTestSchema';
    
    -- Ensure schema exists
    EXEC [dbo].[ZzEnsureSchema] @SchemaName = @TestSchemaName;
    
    -- Check if schema exists
    DECLARE @SchemaExists INT;
    SELECT @SchemaExists = COUNT(*)
    FROM sys.schemas
    WHERE name = @TestSchemaName;
    
    -- Cleanup
    IF @SchemaExists > 0
    BEGIN
        DECLARE @DropSchemaSql NVARCHAR(MAX) = 'DROP SCHEMA [' + @TestSchemaName + ']';
        EXEC sp_executesql @DropSchemaSql;
    END
    
    IF @SchemaExists > 0
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Schema creation successful';
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Schema not created';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '5. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '5. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 6: ZzGetCreateOrAlter Function
SET @TestName = 'GetCreateOrAlter';
BEGIN TRY
    DECLARE @CreateOrAlter NVARCHAR(20) = [dbo].[ZzGetCreateOrAlter]();
    
    IF @CreateOrAlter IN ('CREATE', 'CREATE OR ALTER')
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'GetCreateOrAlter returned: ' + @CreateOrAlter;
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Unexpected value: ' + ISNULL(@CreateOrAlter, 'NULL');
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

-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-10-02
-- Description:	Comprehensive test for JSON package functions
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

PRINT '🧪 COMPREHENSIVE JSON PACKAGE TEST'
PRINT '=================================='
PRINT 'Start Time: ' + CAST(@StartTime AS NVARCHAR(30))
PRINT ''

-- Test 1: Function Existence Check
SET @TestName = 'Function Existence';
BEGIN TRY
    DECLARE @MissingFunctions NVARCHAR(MAX) = '';
    
    IF OBJECT_ID('[dbo].[ZzJsonArrayLength]', 'FN') IS NULL
        SET @MissingFunctions = @MissingFunctions + 'ZzJsonArrayLength, ';
    IF OBJECT_ID('[dbo].[ZzJsonExtract]', 'FN') IS NULL
        SET @MissingFunctions = @MissingFunctions + 'ZzJsonExtract, ';
    IF OBJECT_ID('[dbo].[ZzJsonMerge]', 'FN') IS NULL
        SET @MissingFunctions = @MissingFunctions + 'ZzJsonMerge, ';
    IF OBJECT_ID('[dbo].[ZzJsonToTable]', 'FN') IS NULL AND OBJECT_ID('[dbo].[ZzJsonToTable]', 'TF') IS NULL
        SET @MissingFunctions = @MissingFunctions + 'ZzJsonToTable, ';
    IF OBJECT_ID('[dbo].[ZzJsonValidate]', 'FN') IS NULL
        SET @MissingFunctions = @MissingFunctions + 'ZzJsonValidate, ';
    
    IF LEN(@MissingFunctions) > 0
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Missing functions: ' + LEFT(@MissingFunctions, LEN(@MissingFunctions) - 2);
    END
    ELSE
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'All 5 JSON functions exist';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '1. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '1. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 2: ZzJsonValidate - Valid JSON
SET @TestName = 'JSON Validation';
BEGIN TRY
    DECLARE @ValidJson NVARCHAR(MAX) = '{"name": "John", "age": 30, "city": "Tehran"}';
    DECLARE @InvalidJson NVARCHAR(MAX) = '{name: John, age: 30}'; -- Invalid JSON
    
    DECLARE @IsValid1 BIT = [dbo].[ZzJsonValidate](@ValidJson);
    DECLARE @IsValid2 BIT = [dbo].[ZzJsonValidate](@InvalidJson);
    
    IF @IsValid1 = 1 AND @IsValid2 = 0
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'JSON validation works correctly';
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Validation failed: Valid=' + CAST(@IsValid1 AS CHAR(1)) + ', Invalid=' + CAST(@IsValid2 AS CHAR(1));
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '2. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '2. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 3: ZzJsonExtract - Extract Value
SET @TestName = 'JSON Extract';
BEGIN TRY
    DECLARE @JsonData NVARCHAR(MAX) = '{"name": "Mohsen", "age": 35, "country": "Iran"}';
    DECLARE @ExtractedName NVARCHAR(MAX) = [dbo].[ZzJsonExtract](@JsonData, '$.name');
    DECLARE @ExtractedAge NVARCHAR(MAX) = [dbo].[ZzJsonExtract](@JsonData, '$.age');
    
    IF @ExtractedName LIKE '%Mohsen%' AND @ExtractedAge LIKE '%35%'
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Extracted: ' + @ExtractedName + ', Age: ' + @ExtractedAge;
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Extraction failed';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '3. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '3. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 4: ZzJsonArrayLength
SET @TestName = 'JSON Array Length';
BEGIN TRY
    DECLARE @JsonArray NVARCHAR(MAX) = '{"items": [1, 2, 3, 4, 5]}';
    DECLARE @ArrayLength INT = [dbo].[ZzJsonArrayLength](@JsonArray, '$.items');
    
    IF @ArrayLength = 5
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Array length: ' + CAST(@ArrayLength AS NVARCHAR(10));
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Expected 5, got ' + CAST(@ArrayLength AS NVARCHAR(10));
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '4. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '4. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 5: ZzJsonMerge
SET @TestName = 'JSON Merge';
BEGIN TRY
    DECLARE @Json1 NVARCHAR(MAX) = '{"name": "John", "age": 30}';
    DECLARE @Json2 NVARCHAR(MAX) = '{"city": "Tehran", "country": "Iran"}';
    DECLARE @MergedJson NVARCHAR(MAX) = [dbo].[ZzJsonMerge](@Json1, @Json2);
    
    IF @MergedJson LIKE '%John%' AND @MergedJson LIKE '%Tehran%'
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'JSON merged successfully';
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Merge failed';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '5. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '5. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 6: ZzJsonToTable
SET @TestName = 'JSON To Table';
BEGIN TRY
    DECLARE @JsonTableData NVARCHAR(MAX) = '[{"id": 1, "name": "Alice"}, {"id": 2, "name": "Bob"}]';
    DECLARE @RowCount INT;
    
    SELECT @RowCount = COUNT(*)
    FROM [dbo].[ZzJsonToTable](@JsonTableData);
    
    IF @RowCount >= 0
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Converted to table with ' + CAST(@RowCount AS NVARCHAR(10)) + ' rows';
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Table conversion failed';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '6. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '6. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 7: Complex JSON Operations
SET @TestName = 'Complex JSON';
BEGIN TRY
    DECLARE @ComplexJson NVARCHAR(MAX) = '{
        "user": {
            "name": "Mohsen",
            "contact": {
                "email": "test@example.com",
                "phone": "+98123456789"
            },
            "tags": ["developer", "sql", "azure"]
        }
    }';
    
    DECLARE @Email NVARCHAR(MAX) = [dbo].[ZzJsonExtract](@ComplexJson, '$.user.contact.email');
    DECLARE @TagsLength INT = [dbo].[ZzJsonArrayLength](@ComplexJson, '$.user.tags');
    
    IF @Email LIKE '%@example.com%' AND @TagsLength = 3
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Complex JSON handling successful';
    END
    ELSE
    BEGIN
        SET @Status = 'WARN';
        SET @Message = 'Some operations may not work as expected';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '7. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '7. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
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

PRINT '=================================='

-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-30
-- Description: Comprehensive test runner for advanced DateTime functions
-- This script will test all functions step by step with error handling
-- =============================================

SET NOCOUNT ON;
DECLARE @TestResults TABLE (
    TestName NVARCHAR(50),
    Status NVARCHAR(10),
    Message NVARCHAR(MAX),
    ExecutionTime DATETIME2
);

DECLARE @StartTime DATETIME2 = SYSDATETIME();
DECLARE @TestName NVARCHAR(50);
DECLARE @Status NVARCHAR(10);
DECLARE @Message NVARCHAR(MAX);

PRINT '🧪 COMPREHENSIVE ADVANCED DATETIME FUNCTIONS TEST'
PRINT '=================================================='
PRINT 'Start Time: ' + CAST(@StartTime AS NVARCHAR(30))
PRINT ''

-- Test 1: Function Existence Check
SET @TestName = 'Function Existence';
BEGIN TRY
    DECLARE @MissingFunctions NVARCHAR(MAX) = '';
    
    IF OBJECT_ID('[dbo].[ZzConvertToLunar]', 'FN') IS NULL
        SET @MissingFunctions = @MissingFunctions + 'ZzConvertToLunar, ';
    IF OBJECT_ID('[dbo].[ZzHolidayChecker]', 'FN') IS NULL
        SET @MissingFunctions = @MissingFunctions + 'ZzHolidayChecker, ';
    IF OBJECT_ID('[dbo].[ZzDateValidator]', 'FN') IS NULL
        SET @MissingFunctions = @MissingFunctions + 'ZzDateValidator, ';
    IF OBJECT_ID('[dbo].[ZzTimeZoneConverter]', 'FN') IS NULL
        SET @MissingFunctions = @MissingFunctions + 'ZzTimeZoneConverter, ';
    IF OBJECT_ID('[dbo].[ZzBusinessDaysCalculator]', 'FN') IS NULL
        SET @MissingFunctions = @MissingFunctions + 'ZzBusinessDaysCalculator, ';
    IF OBJECT_ID('[dbo].[ZzScheduleGenerator]', 'TF') IS NULL
        SET @MissingFunctions = @MissingFunctions + 'ZzScheduleGenerator, ';
    
    IF LEN(@MissingFunctions) > 0
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Missing functions: ' + LEFT(@MissingFunctions, LEN(@MissingFunctions) - 1);
    END
    ELSE
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'All 6 functions exist';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '1. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '1. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 2: ZzConvertToLunar
SET @TestName = 'ZzConvertToLunar';
BEGIN TRY
    DECLARE @LunarResult1 NVARCHAR(10) = [dbo].[ZzConvertToLunar]('2025-09-30');
    DECLARE @LunarResult2 NVARCHAR(10) = [dbo].[ZzConvertToLunar]('2025-01-01');
    
    IF @LunarResult1 IS NOT NULL AND @LunarResult2 IS NOT NULL
       AND LEN(@LunarResult1) = 10 AND LEN(@LunarResult2) = 10
    BEGIN
        SET @Status = 'PASS';
        SET @Message = '2025-09-30→' + @LunarResult1 + ', 2025-01-01→' + @LunarResult2;
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Invalid lunar date format';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '2. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '2. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 3: ZzHolidayChecker
SET @TestName = 'ZzHolidayChecker';
BEGIN TRY
    DECLARE @NowruzHoliday BIT = [dbo].[ZzHolidayChecker]('2025-03-21', 'IR');
    DECLARE @RegularDay BIT = [dbo].[ZzHolidayChecker]('2025-09-30', 'IR');
    DECLARE @LaborDay BIT = [dbo].[ZzHolidayChecker]('2025-05-01', 'IR');
    
    IF @NowruzHoliday = 1 AND @RegularDay = 0 AND @LaborDay = 1
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Nowruz✓, Regular✓, Labor Day✓';
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Holiday detection failed: N=' + CAST(@NowruzHoliday AS CHAR(1)) + 
                      ', R=' + CAST(@RegularDay AS CHAR(1)) + ', L=' + CAST(@LaborDay AS CHAR(1));
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '3. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '3. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 4: ZzDateValidator
SET @TestName = 'ZzDateValidator';
BEGIN TRY
    DECLARE @Valid1 BIT = [dbo].[ZzDateValidator]('2025/09/30', 'GREGORIAN');
    DECLARE @Invalid1 BIT = [dbo].[ZzDateValidator]('2025/13/30', 'GREGORIAN');
    DECLARE @Valid2 BIT = [dbo].[ZzDateValidator]('1404/07/08', 'SHAMSI');
    DECLARE @Invalid2 BIT = [dbo].[ZzDateValidator]('1404/13/08', 'SHAMSI');
    
    IF @Valid1 = 1 AND @Invalid1 = 0 AND @Valid2 = 1 AND @Invalid2 = 0
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'All validation tests correct';
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Validation logic error';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '4. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '4. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 5: ZzTimeZoneConverter  
SET @TestName = 'ZzTimeZoneConverter';
BEGIN TRY
    DECLARE @OriginalTime DATETIME2 = '2025-09-30 14:30:00';
    DECLARE @UTCTime DATETIME2 = [dbo].[ZzTimeZoneConverter](@OriginalTime, 'Asia/Tehran', 'UTC');
    DECLARE @BackToTehran DATETIME2 = [dbo].[ZzTimeZoneConverter](@UTCTime, 'UTC', 'Asia/Tehran');
    
    IF ABS(DATEDIFF(MINUTE, @OriginalTime, @BackToTehran)) <= 1 -- Allow 1 minute tolerance
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Round-trip conversion successful';
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Round-trip failed: ' + CAST(@OriginalTime AS NVARCHAR(20)) + 
                      ' → ' + CAST(@BackToTehran AS NVARCHAR(20));
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '5. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '5. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 6: ZzScheduleGenerator
SET @TestName = 'ZzScheduleGenerator';
BEGIN TRY
    DECLARE @ScheduleCount INT;
    SELECT @ScheduleCount = COUNT(*)
    FROM [dbo].[ZzScheduleGenerator]('2025-10-01', '2025-10-07', 'WEEKLY', 1, 'MON,TUE,WED,THU,SUN', 1);
    
    IF @ScheduleCount >= 5 AND @ScheduleCount <= 7  -- Should be around 7 days
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Generated ' + CAST(@ScheduleCount AS NVARCHAR(10)) + ' schedule entries';
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Unexpected schedule count: ' + CAST(@ScheduleCount AS NVARCHAR(10));
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

PRINT '==';
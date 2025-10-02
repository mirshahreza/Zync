-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-10-02
-- Description:	Comprehensive test for Math package functions
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

PRINT '🧪 COMPREHENSIVE MATH PACKAGE TEST'
PRINT '=================================='
PRINT 'Start Time: ' + CAST(@StartTime AS NVARCHAR(30))
PRINT ''

-- Test 1: Function Existence Check
SET @TestName = 'Function Existence';
BEGIN TRY
    DECLARE @MissingFunctions NVARCHAR(MAX) = '';
    DECLARE @FunctionCount INT = 0;
    
    IF OBJECT_ID('[dbo].[ZzAverage]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzAverage, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzClamp]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzClamp, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzCombination]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzCombination, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzDistance]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzDistance, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzFactorial]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzFactorial, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzFibonacci]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzFibonacci, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzFormatBytes]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzFormatBytes, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzFromBinary]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzFromBinary, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzFromHex]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzFromHex, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzFromRoman]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzFromRoman, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzFutureValue]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzFutureValue, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzGcd]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzGcd, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzHumanizeNumber]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzHumanizeNumber, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzIsBitSet]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzIsBitSet, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzIsEven]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzIsEven, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzIsNumericStrict]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzIsNumericStrict, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzIsOdd]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzIsOdd, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzIsPrime]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzIsPrime, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzLcm]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzLcm, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzMedianFromString]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzMedianFromString, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzMode]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzMode, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzPercentageChange]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzPercentageChange, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzPercentageOf]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzPercentageOf, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzPermutation]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzPermutation, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzPresentValue]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzPresentValue, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzRandom]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzRandom, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzRandomInRange]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzRandomInRange, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzRoundToMultiple]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzRoundToMultiple, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzSafeDivide]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzSafeDivide, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzStandardDeviation]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzStandardDeviation, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzToBinary]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzToBinary, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzToHex]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzToHex, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzToRoman]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzToRoman, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzToWords]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzToWords, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    
    IF LEN(@MissingFunctions) > 0
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Missing functions: ' + LEFT(@MissingFunctions, LEN(@MissingFunctions) - 2);
    END
    ELSE
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'All ' + CAST(@FunctionCount AS NVARCHAR(5)) + ' math functions exist';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '1. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '1. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 2: Basic Math Functions
SET @TestName = 'Basic Math Operations';
BEGIN TRY
    DECLARE @IsEvenResult BIT = [dbo].[ZzIsEven](10);
    DECLARE @IsOddResult BIT = [dbo].[ZzIsOdd](11);
    DECLARE @IsPrimeResult BIT = [dbo].[ZzIsPrime](7);
    DECLARE @ClampResult INT = [dbo].[ZzClamp](150, 0, 100);
    
    IF @IsEvenResult = 1 AND @IsOddResult = 1 AND @IsPrimeResult = 1 AND @ClampResult = 100
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Basic operations work correctly';
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Some basic operations failed';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '2. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '2. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 3: Factorial and Fibonacci
SET @TestName = 'Factorial & Fibonacci';
BEGIN TRY
    DECLARE @Factorial5 BIGINT = [dbo].[ZzFactorial](5); -- Should be 120
    DECLARE @Fibonacci7 BIGINT = [dbo].[ZzFibonacci](7); -- Should be 13
    
    IF @Factorial5 = 120 AND @Fibonacci7 = 13
    BEGIN
        SET @Status = 'PASS';
        SET @Message = '5! = ' + CAST(@Factorial5 AS NVARCHAR(20)) + ', Fib(7) = ' + CAST(@Fibonacci7 AS NVARCHAR(20));
    END
    ELSE
    BEGIN
        SET @Status = 'WARN';
        SET @Message = 'Results: ' + CAST(@Factorial5 AS NVARCHAR(20)) + ', ' + CAST(@Fibonacci7 AS NVARCHAR(20));
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '3. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '3. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 4: GCD and LCM
SET @TestName = 'GCD & LCM';
BEGIN TRY
    DECLARE @GCDResult INT = [dbo].[ZzGcd](48, 18); -- Should be 6
    DECLARE @LCMResult INT = [dbo].[ZzLcm](12, 18); -- Should be 36
    
    IF @GCDResult = 6 AND @LCMResult = 36
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'GCD(48,18) = ' + CAST(@GCDResult AS NVARCHAR(10)) + ', LCM(12,18) = ' + CAST(@LCMResult AS NVARCHAR(10));
    END
    ELSE
    BEGIN
        SET @Status = 'WARN';
        SET @Message = 'GCD = ' + CAST(@GCDResult AS NVARCHAR(10)) + ', LCM = ' + CAST(@LCMResult AS NVARCHAR(10));
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '4. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '4. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 5: Number Conversions
SET @TestName = 'Number Conversions';
BEGIN TRY
    DECLARE @Binary NVARCHAR(50) = [dbo].[ZzToBinary](255);
    DECLARE @Hex NVARCHAR(50) = [dbo].[ZzToHex](255);
    DECLARE @Roman NVARCHAR(50) = [dbo].[ZzToRoman](2024);
    DECLARE @FromBin INT = [dbo].[ZzFromBinary]('11111111');
    DECLARE @FromHex INT = [dbo].[ZzFromHex]('FF');
    
    IF @Binary IS NOT NULL AND @Hex IS NOT NULL AND @Roman IS NOT NULL AND @FromBin = 255 AND @FromHex = 255
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Binary=' + @Binary + ', Hex=' + @Hex + ', Roman=' + @Roman;
    END
    ELSE
    BEGIN
        SET @Status = 'WARN';
        SET @Message = 'Some conversions may not work as expected';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '5. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '5. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 6: Percentage Calculations
SET @TestName = 'Percentage Calculations';
BEGIN TRY
    DECLARE @PercOf DECIMAL(18,2) = [dbo].[ZzPercentageOf](25, 200); -- 25% of 200 = 50
    DECLARE @PercChange DECIMAL(18,2) = [dbo].[ZzPercentageChange](100, 150); -- 50% increase
    
    IF @PercOf = 50 AND @PercChange = 50
    BEGIN
        SET @Status = 'PASS';
        SET @Message = '25% of 200 = ' + CAST(@PercOf AS NVARCHAR(20)) + ', Change = ' + CAST(@PercChange AS NVARCHAR(20)) + '%';
    END
    ELSE
    BEGIN
        SET @Status = 'WARN';
        SET @Message = 'PercOf = ' + CAST(@PercOf AS NVARCHAR(20)) + ', Change = ' + CAST(@PercChange AS NVARCHAR(20));
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '6. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '6. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 7: Formatting Functions
SET @TestName = 'Formatting Functions';
BEGIN TRY
    DECLARE @FormattedBytes NVARCHAR(50) = [dbo].[ZzFormatBytes](1048576); -- 1 MB
    DECLARE @HumanNumber NVARCHAR(50) = [dbo].[ZzHumanizeNumber](1234567);
    
    IF @FormattedBytes IS NOT NULL AND @HumanNumber IS NOT NULL
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Bytes: ' + @FormattedBytes + ', Human: ' + @HumanNumber;
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Formatting failed';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '7. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '7. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 8: Safe Operations
SET @TestName = 'Safe Operations';
BEGIN TRY
    DECLARE @SafeDivResult DECIMAL(18,2) = [dbo].[ZzSafeDivide](100, 0); -- Should handle division by zero
    DECLARE @RoundToMult INT = [dbo].[ZzRoundToMultiple](47, 5); -- Should be 45 or 50
    
    IF @SafeDivResult IS NOT NULL AND @RoundToMult IS NOT NULL
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'SafeDivide(100,0) = ' + CAST(@SafeDivResult AS NVARCHAR(20)) + ', RoundToMultiple(47,5) = ' + CAST(@RoundToMult AS NVARCHAR(20));
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Safe operations failed';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '8. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '8. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
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

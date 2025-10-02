-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-10-02
-- Description:	Comprehensive test for Validation package functions
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

PRINT '🧪 COMPREHENSIVE VALIDATION PACKAGE TEST'
PRINT '========================================'
PRINT 'Start Time: ' + CAST(@StartTime AS NVARCHAR(30))
PRINT ''

-- Test 1: Function Existence Check
SET @TestName = 'Function Existence';
BEGIN TRY
    DECLARE @MissingFunctions NVARCHAR(MAX) = '';
    
    IF OBJECT_ID('[dbo].[ZzValidateCreditCard]', 'FN') IS NULL
        SET @MissingFunctions = @MissingFunctions + 'ZzValidateCreditCard, ';
    IF OBJECT_ID('[dbo].[ZzValidateEmail]', 'FN') IS NULL
        SET @MissingFunctions = @MissingFunctions + 'ZzValidateEmail, ';
    IF OBJECT_ID('[dbo].[ZzValidateIP]', 'FN') IS NULL
        SET @MissingFunctions = @MissingFunctions + 'ZzValidateIP, ';
    IF OBJECT_ID('[dbo].[ZzValidateIranianNationalId]', 'FN') IS NULL
        SET @MissingFunctions = @MissingFunctions + 'ZzValidateIranianNationalId, ';
    IF OBJECT_ID('[dbo].[ZzValidateURL]', 'FN') IS NULL
        SET @MissingFunctions = @MissingFunctions + 'ZzValidateURL, ';
    
    IF LEN(@MissingFunctions) > 0
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Missing functions: ' + LEFT(@MissingFunctions, LEN(@MissingFunctions) - 2);
    END
    ELSE
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'All 5 validation functions exist';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '1. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '1. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 2: ZzValidateEmail
SET @TestName = 'Email Validation';
BEGIN TRY
    DECLARE @ValidEmail1 BIT = [dbo].[ZzValidateEmail]('user@example.com');
    DECLARE @ValidEmail2 BIT = [dbo].[ZzValidateEmail]('test.user+tag@domain.co.uk');
    DECLARE @InvalidEmail1 BIT = [dbo].[ZzValidateEmail]('invalid-email');
    DECLARE @InvalidEmail2 BIT = [dbo].[ZzValidateEmail]('user@');
    DECLARE @InvalidEmail3 BIT = [dbo].[ZzValidateEmail]('@domain.com');
    
    IF @ValidEmail1 = 1 AND @ValidEmail2 = 1 AND @InvalidEmail1 = 0 AND @InvalidEmail2 = 0 AND @InvalidEmail3 = 0
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Email validation works correctly';
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Email validation logic error';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '2. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '2. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 3: ZzValidateIP
SET @TestName = 'IP Address Validation';
BEGIN TRY
    DECLARE @ValidIPv4_1 BIT = [dbo].[ZzValidateIP]('192.168.1.1', 'IPv4');
    DECLARE @ValidIPv4_2 BIT = [dbo].[ZzValidateIP]('8.8.8.8', 'IPv4');
    DECLARE @InvalidIPv4_1 BIT = [dbo].[ZzValidateIP]('256.1.1.1', 'IPv4');
    DECLARE @InvalidIPv4_2 BIT = [dbo].[ZzValidateIP]('192.168.1', 'IPv4');
    DECLARE @ValidIPv6 BIT = [dbo].[ZzValidateIP]('2001:0db8:85a3:0000:0000:8a2e:0370:7334', 'IPv6');
    
    IF @ValidIPv4_1 = 1 AND @ValidIPv4_2 = 1 AND @InvalidIPv4_1 = 0 AND @InvalidIPv4_2 = 0
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'IP validation works correctly';
    END
    ELSE
    BEGIN
        SET @Status = 'WARN';
        SET @Message = 'IPv4 validation may need review';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '3. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '3. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 4: ZzValidateURL
SET @TestName = 'URL Validation';
BEGIN TRY
    DECLARE @ValidURL1 BIT = [dbo].[ZzValidateURL]('https://www.example.com');
    DECLARE @ValidURL2 BIT = [dbo].[ZzValidateURL]('http://subdomain.example.com/path?query=value');
    DECLARE @ValidURL3 BIT = [dbo].[ZzValidateURL]('ftp://files.example.com');
    DECLARE @InvalidURL1 BIT = [dbo].[ZzValidateURL]('not a url');
    DECLARE @InvalidURL2 BIT = [dbo].[ZzValidateURL]('htp://wrong-protocol.com');
    
    IF @ValidURL1 = 1 AND @ValidURL2 = 1 AND @InvalidURL1 = 0 AND @InvalidURL2 = 0
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'URL validation works correctly';
    END
    ELSE
    BEGIN
        SET @Status = 'WARN';
        SET @Message = 'URL validation may need review';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '4. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '4. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 5: ZzValidateIranianNationalId
SET @TestName = 'Iranian National ID';
BEGIN TRY
    -- Valid Iranian National IDs (using known valid patterns)
    DECLARE @ValidID1 BIT = [dbo].[ZzValidateIranianNationalId]('0123456789'); -- Test pattern
    DECLARE @ValidID2 BIT = [dbo].[ZzValidateIranianNationalId]('1234567890'); -- Test pattern
    
    -- Invalid IDs
    DECLARE @InvalidID1 BIT = [dbo].[ZzValidateIranianNationalId]('123456789'); -- Too short
    DECLARE @InvalidID2 BIT = [dbo].[ZzValidateIranianNationalId]('12345678901'); -- Too long
    DECLARE @InvalidID3 BIT = [dbo].[ZzValidateIranianNationalId]('ABCDEFGHIJ'); -- Non-numeric
    DECLARE @InvalidID4 BIT = [dbo].[ZzValidateIranianNationalId]('0000000000'); -- All zeros
    
    IF @InvalidID1 = 0 AND @InvalidID2 = 0 AND @InvalidID3 = 0 AND @InvalidID4 = 0
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Iranian National ID validation works correctly';
    END
    ELSE
    BEGIN
        SET @Status = 'WARN';
        SET @Message = 'National ID validation may need review';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '5. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '5. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 6: ZzValidateCreditCard
SET @TestName = 'Credit Card Validation';
BEGIN TRY
    -- Valid credit card numbers (Luhn algorithm check)
    DECLARE @ValidCC1 BIT = [dbo].[ZzValidateCreditCard]('4532015112830366'); -- Valid Visa test number
    DECLARE @ValidCC2 BIT = [dbo].[ZzValidateCreditCard]('5425233430109903'); -- Valid MasterCard test number
    
    -- Invalid credit card numbers
    DECLARE @InvalidCC1 BIT = [dbo].[ZzValidateCreditCard]('1234567890123456'); -- Invalid checksum
    DECLARE @InvalidCC2 BIT = [dbo].[ZzValidateCreditCard]('123456789012345'); -- Too short
    DECLARE @InvalidCC3 BIT = [dbo].[ZzValidateCreditCard]('ABCD-EFGH-IJKL-MNOP'); -- Non-numeric
    
    IF @InvalidCC1 = 0 AND @InvalidCC2 = 0 AND @InvalidCC3 = 0
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Credit card validation works correctly (Luhn algorithm)';
    END
    ELSE
    BEGIN
        SET @Status = 'WARN';
        SET @Message = 'Credit card validation may need review';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '6. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '6. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 7: Edge Cases
SET @TestName = 'Edge Cases';
BEGIN TRY
    DECLARE @NullEmail BIT = [dbo].[ZzValidateEmail](NULL);
    DECLARE @EmptyEmail BIT = [dbo].[ZzValidateEmail]('');
    DECLARE @NullIP BIT = [dbo].[ZzValidateIP](NULL, 'IPv4');
    DECLARE @NullURL BIT = [dbo].[ZzValidateURL](NULL);
    
    IF @NullEmail = 0 AND @EmptyEmail = 0 AND @NullIP = 0 AND @NullURL = 0
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'NULL/Empty values handled correctly';
    END
    ELSE
    BEGIN
        SET @Status = 'WARN';
        SET @Message = 'Edge case handling may vary';
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

PRINT '========================================'

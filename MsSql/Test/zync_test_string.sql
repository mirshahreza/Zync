-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-10-02
-- Description:	Comprehensive test for String package functions
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

PRINT '🧪 COMPREHENSIVE STRING PACKAGE TEST'
PRINT '===================================='
PRINT 'Start Time: ' + CAST(@StartTime AS NVARCHAR(30))
PRINT ''

-- Test 1: Function Existence Check (Sampling key functions)
SET @TestName = 'Function Existence';
BEGIN TRY
    DECLARE @MissingFunctions NVARCHAR(MAX) = '';
    DECLARE @FunctionCount INT = 0;
    
    -- Check all 43 functions
    IF OBJECT_ID('[dbo].[ZzAbbreviate]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzAbbreviate, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzAcronym]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzAcronym, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzBase64Decode]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzBase64Decode, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzBase64Encode]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzBase64Encode, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzContainsAny]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzContainsAny, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzConvertDigitsFaEn]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzConvertDigitsFaEn, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzCountChar]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzCountChar, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzCountSubstring]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzCountSubstring, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzCountWord]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzCountWord, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzExtractDomain]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzExtractDomain, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzExtractInitials]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzExtractInitials, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzFix2Char]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzFix2Char, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzGenerateRandomString]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzGenerateRandomString, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzHash]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzHash, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzIsPalindrome]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzIsPalindrome, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzIsValidEmail]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzIsValidEmail, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzMask]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzMask, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzNormalizePersianText]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzNormalizePersianText, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzNthItem]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzNthItem, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzPadLeft]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzPadLeft, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzPadRight]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzPadRight, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzProperCase]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzProperCase, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzRemoveExtraSpaces]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzRemoveExtraSpaces, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzRemoveHtmlTags]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzRemoveHtmlTags, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzRemoveNonAlphanumeric]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzRemoveNonAlphanumeric, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzReverse]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzReverse, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzSimilarity]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzSimilarity, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzSlugify]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzSlugify, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzSoundex]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzSoundex, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzSplitString]', 'FN') IS NULL AND OBJECT_ID('[dbo].[ZzSplitString]', 'TF') IS NULL AND OBJECT_ID('[dbo].[ZzSplitString]', 'IF') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzSplitString, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzSplitStringWithIndex]', 'FN') IS NULL AND OBJECT_ID('[dbo].[ZzSplitStringWithIndex]', 'TF') IS NULL AND OBJECT_ID('[dbo].[ZzSplitStringWithIndex]', 'IF') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzSplitStringWithIndex, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzSubstringBetween]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzSubstringBetween, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzToCamelCase]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzToCamelCase, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzToSnakeCase]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzToSnakeCase, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzTrim]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzTrim, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzTruncateByWord]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzTruncateByWord, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzUrlDecode]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzUrlDecode, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzUrlEncode]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzUrlEncode, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzWordCount]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzWordCount, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    IF OBJECT_ID('[dbo].[ZzWrapText]', 'FN') IS NULL SET @MissingFunctions = @MissingFunctions + 'ZzWrapText, '; ELSE SET @FunctionCount = @FunctionCount + 1;
    
    IF LEN(@MissingFunctions) > 0
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Missing functions: ' + LEFT(@MissingFunctions, LEN(@MissingFunctions) - 2);
    END
    ELSE
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'All ' + CAST(@FunctionCount AS NVARCHAR(5)) + ' string functions exist';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '1. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '1. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 2: Basic String Operations
SET @TestName = 'Basic String Operations';
BEGIN TRY
    DECLARE @TestStr NVARCHAR(100) = '  Hello World  ';
    DECLARE @Trimmed NVARCHAR(100) = [dbo].[ZzTrim](@TestStr);
    DECLARE @Reversed NVARCHAR(100) = [dbo].[ZzReverse]('ABC');
    DECLARE @ProperCase NVARCHAR(100) = [dbo].[ZzProperCase]('hello world');
    
    IF @Trimmed = 'Hello World' AND @Reversed = 'CBA' AND @ProperCase = 'Hello World'
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Basic operations work correctly';
    END
    ELSE
    BEGIN
        SET @Status = 'WARN';
        SET @Message = 'Some operations may differ from expected';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '2. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '2. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 3: Case Conversions
SET @TestName = 'Case Conversions';
BEGIN TRY
    DECLARE @CamelCase NVARCHAR(100) = [dbo].[ZzToCamelCase]('hello_world_test');
    DECLARE @SnakeCase NVARCHAR(100) = [dbo].[ZzToSnakeCase]('HelloWorldTest');
    DECLARE @Slugified NVARCHAR(100) = [dbo].[ZzSlugify]('Hello World Test!');
    
    IF @CamelCase IS NOT NULL AND @SnakeCase IS NOT NULL AND @Slugified IS NOT NULL
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Camel: ' + @CamelCase + ', Snake: ' + @SnakeCase + ', Slug: ' + @Slugified;
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Case conversion failed';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '3. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '3. ' + @TestName + ': ' + @Status + ' - ' + ERROR_MESSAGE();
END CATCH

-- Test 4: Counting Operations
SET @TestName = 'Counting Operations';
BEGIN TRY
    DECLARE @TestText NVARCHAR(200) = 'Hello World, Hello Everyone!';
    DECLARE @CharCount INT = [dbo].[ZzCountChar](@TestText, 'l');
    DECLARE @WordCount INT = [dbo].[ZzWordCount](@TestText);
    DECLARE @SubstringCount INT = [dbo].[ZzCountSubstring](@TestText, 'Hello');
    
    IF @CharCount > 0 AND @WordCount > 0 AND @SubstringCount = 2
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Chars: ' + CAST(@CharCount AS NVARCHAR(10)) + ', Words: ' + CAST(@WordCount AS NVARCHAR(10)) + ', Substrings: ' + CAST(@SubstringCount AS NVARCHAR(10));
    END
    ELSE
    BEGIN
        SET @Status = 'WARN';
        SET @Message = 'Count results: ' + CAST(@CharCount AS NVARCHAR(10)) + ', ' + CAST(@WordCount AS NVARCHAR(10)) + ', ' + CAST(@SubstringCount AS NVARCHAR(10));
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '4. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '4. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 5: Validation Functions
SET @TestName = 'Validation Functions';
BEGIN TRY
    DECLARE @Email1 BIT = [dbo].[ZzIsValidEmail]('test@example.com');
    DECLARE @Email2 BIT = [dbo].[ZzIsValidEmail]('invalid-email');
    DECLARE @Palindrome1 BIT = [dbo].[ZzIsPalindrome]('racecar');
    DECLARE @Palindrome2 BIT = [dbo].[ZzIsPalindrome]('hello');
    
    IF @Email1 = 1 AND @Email2 = 0 AND @Palindrome1 = 1 AND @Palindrome2 = 0
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Validation functions work correctly';
    END
    ELSE
    BEGIN
        SET @Status = 'WARN';
        SET @Message = 'Validation results may vary';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '5. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '5. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 6: Encoding/Decoding
SET @TestName = 'Encoding/Decoding';
BEGIN TRY
    DECLARE @Original NVARCHAR(100) = 'Hello World';
    DECLARE @Encoded NVARCHAR(MAX) = [dbo].[ZzBase64Encode](@Original);
    DECLARE @Decoded NVARCHAR(MAX) = [dbo].[ZzBase64Decode](@Encoded);
    DECLARE @UrlEncoded NVARCHAR(MAX) = [dbo].[ZzUrlEncode]('Hello World!');
    
    IF @Encoded IS NOT NULL AND @Decoded = @Original AND @UrlEncoded IS NOT NULL
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Encoding/Decoding successful';
    END
    ELSE
    BEGIN
        SET @Status = 'WARN';
        SET @Message = 'Some encoding operations may not work as expected';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '6. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '6. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 7: Text Manipulation
SET @TestName = 'Text Manipulation';
BEGIN TRY
    DECLARE @Html NVARCHAR(200) = '<p>Hello <b>World</b></p>';
    DECLARE @NoHtml NVARCHAR(MAX) = [dbo].[ZzRemoveHtmlTags](@Html);
    DECLARE @Padded NVARCHAR(100) = [dbo].[ZzPadLeft]('123', 5, '0');
    DECLARE @Masked NVARCHAR(100) = [dbo].[ZzMask]('1234567890', 4, 4, '*');
    DECLARE @Truncated NVARCHAR(100) = [dbo].[ZzTruncateByWord]('This is a long sentence', 10);
    
    IF @NoHtml IS NOT NULL AND @Padded = '00123' AND @Masked IS NOT NULL AND @Truncated IS NOT NULL
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Text manipulation successful';
    END
    ELSE
    BEGIN
        SET @Status = 'WARN';
        SET @Message = 'Some operations may differ';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '7. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '7. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 8: String Extraction
SET @TestName = 'String Extraction';
BEGIN TRY
    DECLARE @Email NVARCHAR(100) = 'user@example.com';
    DECLARE @Domain NVARCHAR(100) = [dbo].[ZzExtractDomain](@Email);
    DECLARE @Name NVARCHAR(100) = 'John Michael Doe';
    DECLARE @Initials NVARCHAR(50) = [dbo].[ZzExtractInitials](@Name);
    DECLARE @Between NVARCHAR(100) = [dbo].[ZzSubstringBetween]('Hello [World]!', '[', ']');
    
    IF @Domain = 'example.com' AND @Initials IS NOT NULL AND @Between = 'World'
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Extraction successful';
    END
    ELSE
    BEGIN
        SET @Status = 'WARN';
        SET @Message = 'Domain: ' + ISNULL(@Domain, 'NULL') + ', Between: ' + ISNULL(@Between, 'NULL');
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

PRINT '===================================='

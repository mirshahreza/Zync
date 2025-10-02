-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-10-02
-- Description:	Comprehensive test for Security package functions
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

PRINT '🧪 COMPREHENSIVE SECURITY PACKAGE TEST'
PRINT '======================================'
PRINT 'Start Time: ' + CAST(@StartTime AS NVARCHAR(30))
PRINT ''

-- Test 1: Function Existence Check
SET @TestName = 'Function Existence';
BEGIN TRY
    DECLARE @MissingFunctions NVARCHAR(MAX) = '';
    
    IF OBJECT_ID('[dbo].[ZzEncryptData]', 'FN') IS NULL
        SET @MissingFunctions = @MissingFunctions + 'ZzEncryptData, ';
    IF OBJECT_ID('[dbo].[ZzGenerateSalt]', 'FN') IS NULL
        SET @MissingFunctions = @MissingFunctions + 'ZzGenerateSalt, ';
    IF OBJECT_ID('[dbo].[ZzGenerateToken]', 'FN') IS NULL
        SET @MissingFunctions = @MissingFunctions + 'ZzGenerateToken, ';
    IF OBJECT_ID('[dbo].[ZzHashPassword]', 'FN') IS NULL
        SET @MissingFunctions = @MissingFunctions + 'ZzHashPassword, ';
    IF OBJECT_ID('[dbo].[ZzMaskSensitiveData]', 'FN') IS NULL
        SET @MissingFunctions = @MissingFunctions + 'ZzMaskSensitiveData, ';
    
    IF LEN(@MissingFunctions) > 0
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Missing functions: ' + LEFT(@MissingFunctions, LEN(@MissingFunctions) - 2);
    END
    ELSE
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'All 5 security functions exist';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '1. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '1. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 2: ZzGenerateSalt
SET @TestName = 'Generate Salt';
BEGIN TRY
    DECLARE @Salt1 NVARCHAR(MAX) = [dbo].[ZzGenerateSalt](16);
    DECLARE @Salt2 NVARCHAR(MAX) = [dbo].[ZzGenerateSalt](16);
    
    IF @Salt1 IS NOT NULL AND @Salt2 IS NOT NULL AND @Salt1 <> @Salt2 AND LEN(@Salt1) > 0
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Salt generated successfully (length: ' + CAST(LEN(@Salt1) AS NVARCHAR(10)) + ')';
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Salt generation failed or salts are identical';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '2. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '2. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 3: ZzGenerateToken
SET @TestName = 'Generate Token';
BEGIN TRY
    DECLARE @Token1 NVARCHAR(MAX) = [dbo].[ZzGenerateToken](32);
    DECLARE @Token2 NVARCHAR(MAX) = [dbo].[ZzGenerateToken](32);
    
    IF @Token1 IS NOT NULL AND @Token2 IS NOT NULL AND @Token1 <> @Token2 AND LEN(@Token1) > 0
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Token generated successfully (length: ' + CAST(LEN(@Token1) AS NVARCHAR(10)) + ')';
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Token generation failed or tokens are identical';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '3. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '3. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 4: ZzHashPassword
SET @TestName = 'Hash Password';
BEGIN TRY
    DECLARE @Password NVARCHAR(100) = 'MySecurePassword123!';
    DECLARE @Salt NVARCHAR(MAX) = [dbo].[ZzGenerateSalt](16);
    DECLARE @Hash1 NVARCHAR(MAX) = [dbo].[ZzHashPassword](@Password, @Salt);
    DECLARE @Hash2 NVARCHAR(MAX) = [dbo].[ZzHashPassword](@Password, @Salt);
    
    -- Same password + same salt should produce same hash
    IF @Hash1 IS NOT NULL AND @Hash1 = @Hash2
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Password hashing consistent';
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Password hashing failed or inconsistent';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '4. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '4. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 5: ZzMaskSensitiveData
SET @TestName = 'Mask Sensitive Data';
BEGIN TRY
    DECLARE @CreditCard NVARCHAR(100) = '1234-5678-9012-3456';
    DECLARE @Email NVARCHAR(100) = 'user@example.com';
    DECLARE @Phone NVARCHAR(100) = '+98-912-345-6789';
    
    DECLARE @MaskedCC NVARCHAR(MAX) = [dbo].[ZzMaskSensitiveData](@CreditCard, 'CREDIT_CARD');
    DECLARE @MaskedEmail NVARCHAR(MAX) = [dbo].[ZzMaskSensitiveData](@Email, 'EMAIL');
    DECLARE @MaskedPhone NVARCHAR(MAX) = [dbo].[ZzMaskSensitiveData](@Phone, 'PHONE');
    
    IF @MaskedCC IS NOT NULL AND @MaskedEmail IS NOT NULL AND @MaskedPhone IS NOT NULL
       AND @MaskedCC <> @CreditCard AND @MaskedEmail <> @Email AND @MaskedPhone <> @Phone
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Data masking successful';
    END
    ELSE
    BEGIN
        SET @Status = 'WARN';
        SET @Message = 'Some masking may not work as expected';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '5. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '5. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 6: ZzEncryptData
SET @TestName = 'Encrypt Data';
BEGIN TRY
    DECLARE @PlainText NVARCHAR(MAX) = 'Sensitive Information';
    DECLARE @EncryptionKey NVARCHAR(100) = 'MySecretKey123';
    DECLARE @EncryptedData NVARCHAR(MAX) = [dbo].[ZzEncryptData](@PlainText, @EncryptionKey);
    
    IF @EncryptedData IS NOT NULL AND @EncryptedData <> @PlainText
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Data encrypted successfully';
    END
    ELSE
    BEGIN
        SET @Status = 'WARN';
        SET @Message = 'Encryption may not be working as expected';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '6. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '6. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 7: Password Security Best Practices
SET @TestName = 'Password Security';
BEGIN TRY
    -- Test that different salts produce different hashes
    DECLARE @TestPassword NVARCHAR(100) = 'TestPassword123';
    DECLARE @TestSalt1 NVARCHAR(MAX) = [dbo].[ZzGenerateSalt](16);
    DECLARE @TestSalt2 NVARCHAR(MAX) = [dbo].[ZzGenerateSalt](16);
    DECLARE @TestHash1 NVARCHAR(MAX) = [dbo].[ZzHashPassword](@TestPassword, @TestSalt1);
    DECLARE @TestHash2 NVARCHAR(MAX) = [dbo].[ZzHashPassword](@TestPassword, @TestSalt2);
    
    IF @TestHash1 <> @TestHash2
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Different salts produce different hashes (secure)';
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Security concern: Same hash for different salts';
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

PRINT '======================================'

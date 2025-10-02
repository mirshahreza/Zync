-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-10-02
-- Description:	Comprehensive test for Financial package functions
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

PRINT '🧪 COMPREHENSIVE FINANCIAL PACKAGE TEST'
PRINT '======================================='
PRINT 'Start Time: ' + CAST(@StartTime AS NVARCHAR(30))
PRINT ''

-- Test 1: Function Existence Check
SET @TestName = 'Function Existence';
BEGIN TRY
    DECLARE @MissingFunctions NVARCHAR(MAX) = '';
    
    IF OBJECT_ID('[dbo].[ZzCalculateInterest]', 'FN') IS NULL
        SET @MissingFunctions = @MissingFunctions + 'ZzCalculateInterest, ';
    IF OBJECT_ID('[dbo].[ZzCalculateLoanPayment]', 'FN') IS NULL
        SET @MissingFunctions = @MissingFunctions + 'ZzCalculateLoanPayment, ';
    IF OBJECT_ID('[dbo].[ZzEffectiveAnnualRate]', 'FN') IS NULL
        SET @MissingFunctions = @MissingFunctions + 'ZzEffectiveAnnualRate, ';
    IF OBJECT_ID('[dbo].[ZzFormatCurrency]', 'FN') IS NULL
        SET @MissingFunctions = @MissingFunctions + 'ZzFormatCurrency, ';
    IF OBJECT_ID('[dbo].[ZzFutureValueCompound]', 'FN') IS NULL
        SET @MissingFunctions = @MissingFunctions + 'ZzFutureValueCompound, ';
    IF OBJECT_ID('[dbo].[ZzIPMT]', 'FN') IS NULL
        SET @MissingFunctions = @MissingFunctions + 'ZzIPMT, ';
    IF OBJECT_ID('[dbo].[ZzNominalFromEffective]', 'FN') IS NULL
        SET @MissingFunctions = @MissingFunctions + 'ZzNominalFromEffective, ';
    IF OBJECT_ID('[dbo].[ZzPPMT]', 'FN') IS NULL
        SET @MissingFunctions = @MissingFunctions + 'ZzPPMT, ';
    IF OBJECT_ID('[dbo].[ZzPresentValueCompound]', 'FN') IS NULL
        SET @MissingFunctions = @MissingFunctions + 'ZzPresentValueCompound, ';
    
    IF LEN(@MissingFunctions) > 0
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Missing functions: ' + LEFT(@MissingFunctions, LEN(@MissingFunctions) - 2);
    END
    ELSE
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'All 9 financial functions exist';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '1. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '1. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 2: ZzCalculateInterest - Simple Interest
SET @TestName = 'Calculate Interest';
BEGIN TRY
    DECLARE @Interest DECIMAL(18,2) = [dbo].[ZzCalculateInterest](10000, 5, 2); -- Principal: 10000, Rate: 5%, Time: 2 years
    
    IF @Interest > 0 AND @Interest <= 10000
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Interest calculated: ' + CAST(@Interest AS NVARCHAR(20));
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Unexpected interest value: ' + CAST(@Interest AS NVARCHAR(20));
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '2. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '2. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 3: ZzCalculateLoanPayment - Monthly Payment
SET @TestName = 'Loan Payment Calculation';
BEGIN TRY
    DECLARE @Payment DECIMAL(18,2) = [dbo].[ZzCalculateLoanPayment](100000, 5, 30); -- Loan: 100000, Rate: 5%, Years: 30
    
    IF @Payment > 0 AND @Payment < 100000
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Monthly payment: ' + CAST(@Payment AS NVARCHAR(20));
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Invalid payment value: ' + CAST(@Payment AS NVARCHAR(20));
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '3. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '3. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 4: ZzEffectiveAnnualRate
SET @TestName = 'Effective Annual Rate';
BEGIN TRY
    DECLARE @EAR DECIMAL(18,6) = [dbo].[ZzEffectiveAnnualRate](5, 12); -- Nominal rate: 5%, Compounding: 12 times/year
    
    IF @EAR >= 5 AND @EAR < 6
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'EAR calculated: ' + CAST(@EAR AS NVARCHAR(20)) + '%';
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Invalid EAR: ' + CAST(@EAR AS NVARCHAR(20));
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '4. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '4. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 5: ZzFormatCurrency
SET @TestName = 'Format Currency';
BEGIN TRY
    DECLARE @Formatted NVARCHAR(50) = [dbo].[ZzFormatCurrency](1234567.89, 'USD');
    
    IF @Formatted IS NOT NULL AND LEN(@Formatted) > 0
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Formatted: ' + @Formatted;
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Formatting failed';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '5. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '5. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 6: ZzFutureValueCompound
SET @TestName = 'Future Value (Compound)';
BEGIN TRY
    DECLARE @FV DECIMAL(18,2) = [dbo].[ZzFutureValueCompound](10000, 5, 10, 12); -- Present Value: 10000, Rate: 5%, Years: 10, Periods: 12
    
    IF @FV > 10000 AND @FV < 20000
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Future Value: ' + CAST(@FV AS NVARCHAR(20));
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Invalid FV: ' + CAST(@FV AS NVARCHAR(20));
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '6. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '6. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 7: ZzPresentValueCompound
SET @TestName = 'Present Value (Compound)';
BEGIN TRY
    DECLARE @PV DECIMAL(18,2) = [dbo].[ZzPresentValueCompound](20000, 5, 10, 12); -- Future Value: 20000, Rate: 5%, Years: 10, Periods: 12
    
    IF @PV > 0 AND @PV < 20000
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Present Value: ' + CAST(@PV AS NVARCHAR(20));
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Invalid PV: ' + CAST(@PV AS NVARCHAR(20));
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '7. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '7. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 8: ZzIPMT - Interest Payment
SET @TestName = 'Interest Payment (IPMT)';
BEGIN TRY
    DECLARE @IPMT DECIMAL(18,2) = [dbo].[ZzIPMT](5, 1, 360, 100000); -- Rate: 5%, Period: 1, Total Periods: 360, Principal: 100000
    
    IF @IPMT IS NOT NULL
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Interest payment: ' + CAST(@IPMT AS NVARCHAR(20));
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'IPMT calculation failed';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '8. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '8. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 9: ZzPPMT - Principal Payment
SET @TestName = 'Principal Payment (PPMT)';
BEGIN TRY
    DECLARE @PPMT DECIMAL(18,2) = [dbo].[ZzPPMT](5, 1, 360, 100000); -- Rate: 5%, Period: 1, Total Periods: 360, Principal: 100000
    
    IF @PPMT IS NOT NULL
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Principal payment: ' + CAST(@PPMT AS NVARCHAR(20));
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'PPMT calculation failed';
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '9. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '9. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
END CATCH

-- Test 10: ZzNominalFromEffective
SET @TestName = 'Nominal from Effective';
BEGIN TRY
    DECLARE @NominalRate DECIMAL(18,6) = [dbo].[ZzNominalFromEffective](5.12, 12); -- Effective rate: 5.12%, Periods: 12
    
    IF @NominalRate > 0 AND @NominalRate <= 5.12
    BEGIN
        SET @Status = 'PASS';
        SET @Message = 'Nominal rate: ' + CAST(@NominalRate AS NVARCHAR(20)) + '%';
    END
    ELSE
    BEGIN
        SET @Status = 'FAIL';
        SET @Message = 'Invalid nominal rate: ' + CAST(@NominalRate AS NVARCHAR(20));
    END
    
    INSERT INTO @TestResults VALUES (@TestName, @Status, @Message, SYSDATETIME());
    PRINT '10. ' + @TestName + ': ' + @Status + ' - ' + @Message;
END TRY
BEGIN CATCH
    INSERT INTO @TestResults VALUES (@TestName, 'ERROR', ERROR_MESSAGE(), SYSDATETIME());
    PRINT '10. ' + @TestName + ': ERROR - ' + ERROR_MESSAGE();
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

PRINT '======================================='

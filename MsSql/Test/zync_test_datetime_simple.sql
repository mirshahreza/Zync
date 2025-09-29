-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-30
-- Description:	Simple functional test for advanced DateTime functions
-- =============================================

PRINT 'Simple Functional Test for Advanced DateTime Functions...'
PRINT '========================================================'

-- Test simple cases without dependencies

-- Test ZzConvertToLunar with known date
BEGIN TRY
    SELECT 'ZzConvertToLunar Test:' AS Test, [dbo].[ZzConvertToLunar]('2025-09-30') AS Result
    PRINT 'ZzConvertToLunar: ✓ PASS'
END TRY
BEGIN CATCH  
    PRINT 'ZzConvertToLunar: ✗ FAIL - ' + ERROR_MESSAGE()
END CATCH

-- Test ZzDateValidator with simple cases
BEGIN TRY
    SELECT 'ZzDateValidator Tests:' AS Test,
           [dbo].[ZzDateValidator]('2025/09/30', 'GREGORIAN') AS ValidDate,
           [dbo].[ZzDateValidator]('2025/13/30', 'GREGORIAN') AS InvalidDate
    PRINT 'ZzDateValidator: ✓ PASS'
END TRY
BEGIN CATCH
    PRINT 'ZzDateValidator: ✗ FAIL - ' + ERROR_MESSAGE()
END CATCH

-- Test ZzTimeZoneConverter
BEGIN TRY
    SELECT 'ZzTimeZoneConverter Test:' AS Test,
           [dbo].[ZzTimeZoneConverter]('2025-09-30 14:30:00', 'Asia/Tehran', 'UTC') AS UTCTime
    PRINT 'ZzTimeZoneConverter: ✓ PASS'
END TRY
BEGIN CATCH
    PRINT 'ZzTimeZoneConverter: ✗ FAIL - ' + ERROR_MESSAGE()
END CATCH

PRINT '========================================================'
PRINT 'Simple test completed.'
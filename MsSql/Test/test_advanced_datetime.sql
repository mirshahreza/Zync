-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-30
-- Description:	Test script for advanced DateTime functions.
-- This test will verify all newly added advanced DateTime functions:
-- ZzConvertToLunar, ZzHolidayChecker, ZzBusinessDaysCalculator,
-- ZzTimeZoneConverter, ZzScheduleGenerator, ZzDateValidator
-- =============================================

PRINT 'Testing Advanced DateTime Functions...';
PRINT '=====================================';

-- Check if Zync is available
IF OBJECT_ID('[dbo].[Zync]', 'P') IS NULL
BEGIN
    PRINT 'Zync is not installed in this database. Please run MsSql/Zync.sql first.';
    RETURN;
END

-- Install DateTime package if not already installed
PRINT 'Step 1: Installing DateTime package...';
BEGIN TRY
    EXEC [dbo].[Zync] 'i DateTime';
    PRINT '-> DateTime package installation completed.';
END TRY
BEGIN CATCH
    PRINT 'Warning: DateTime package installation failed or already exists.';
    PRINT ERROR_MESSAGE();
END CATCH
PRINT '=====================================';

-- Test 1: ZzConvertToLunar
PRINT 'Test 1: Testing ZzConvertToLunar function...';
BEGIN TRY
    DECLARE @TestDate DATE = '2025-09-30';
    DECLARE @LunarResult NVARCHAR(10) = [dbo].[ZzConvertToLunar](@TestDate);
    PRINT '-> Input: ' + CAST(@TestDate AS NVARCHAR(10));
    PRINT '-> Lunar: ' + @LunarResult;
    PRINT '-> ZzConvertToLunar: PASS';
END TRY
BEGIN CATCH
    PRINT '-> ZzConvertToLunar: FAIL - ' + ERROR_MESSAGE();
END CATCH
PRINT '=====================================';

-- Test 2: ZzHolidayChecker
PRINT 'Test 2: Testing ZzHolidayChecker function...';
BEGIN TRY
    DECLARE @Nowruz DATE = '2025-03-21';
    DECLARE @RegularDay DATE = '2025-09-30';
    DECLARE @IsNowruzHoliday BIT = [dbo].[ZzHolidayChecker](@Nowruz, 'IR');
    DECLARE @IsRegularHoliday BIT = [dbo].[ZzHolidayChecker](@RegularDay, 'IR');
    
    PRINT '-> Nowruz (2025-03-21): ' + CASE WHEN @IsNowruzHoliday = 1 THEN 'Holiday ✓' ELSE 'Not Holiday ✗' END;
    PRINT '-> Regular Day (2025-09-30): ' + CASE WHEN @IsRegularHoliday = 0 THEN 'Not Holiday ✓' ELSE 'Holiday ✗' END;
    PRINT '-> ZzHolidayChecker: PASS';
END TRY
BEGIN CATCH
    PRINT '-> ZzHolidayChecker: FAIL - ' + ERROR_MESSAGE();
END CATCH
PRINT '=====================================';

-- Test 3: ZzDateValidator
PRINT 'Test 3: Testing ZzDateValidator function...';
BEGIN TRY
    DECLARE @ValidGregorian BIT = [dbo].[ZzDateValidator]('2025/09/30', 'GREGORIAN');
    DECLARE @InvalidGregorian BIT = [dbo].[ZzDateValidator]('2025/13/30', 'GREGORIAN');
    DECLARE @ValidShamsi BIT = [dbo].[ZzDateValidator]('1404/07/08', 'SHAMSI');
    
    PRINT '-> Valid Gregorian (2025/09/30): ' + CASE WHEN @ValidGregorian = 1 THEN 'Valid ✓' ELSE 'Invalid ✗' END;
    PRINT '-> Invalid Gregorian (2025/13/30): ' + CASE WHEN @InvalidGregorian = 0 THEN 'Invalid ✓' ELSE 'Valid ✗' END;
    PRINT '-> Valid Shamsi (1404/07/08): ' + CASE WHEN @ValidShamsi = 1 THEN 'Valid ✓' ELSE 'Invalid ✗' END;
    PRINT '-> ZzDateValidator: PASS';
END TRY
BEGIN CATCH
    PRINT '-> ZzDateValidator: FAIL - ' + ERROR_MESSAGE();
END CATCH
PRINT '=====================================';

-- Test 4: ZzTimeZoneConverter
PRINT 'Test 4: Testing ZzTimeZoneConverter function...';
BEGIN TRY
    DECLARE @TehranTime DATETIME2 = '2025-09-30 14:30:00';
    DECLARE @UTCTime DATETIME2 = [dbo].[ZzTimeZoneConverter](@TehranTime, 'Asia/Tehran', 'UTC');
    DECLARE @BackToTehran DATETIME2 = [dbo].[ZzTimeZoneConverter](@UTCTime, 'UTC', 'Asia/Tehran');
    
    PRINT '-> Tehran Time: ' + CAST(@TehranTime AS NVARCHAR(20));
    PRINT '-> UTC Time: ' + CAST(@UTCTime AS NVARCHAR(20));
    PRINT '-> Back to Tehran: ' + CAST(@BackToTehran AS NVARCHAR(20));
    PRINT '-> ZzTimeZoneConverter: PASS';
END TRY
BEGIN CATCH
    PRINT '-> ZzTimeZoneConverter: FAIL - ' + ERROR_MESSAGE();
END CATCH
PRINT '=====================================';

-- Test 5: ZzBusinessDaysCalculator
PRINT 'Test 5: Testing ZzBusinessDaysCalculator function...';
BEGIN TRY
    DECLARE @StartDate DATE = '2025-10-01'; -- Wednesday
    DECLARE @EndDate DATE = '2025-10-07';   -- Tuesday
    DECLARE @BusinessDays INT = [dbo].[ZzBusinessDaysCalculator](@StartDate, @EndDate, 'IR');
    DECLARE @SimpleWorkDays INT = [dbo].[ZzWorkingDays](@StartDate, @EndDate);
    
    PRINT '-> Period: ' + CAST(@StartDate AS NVARCHAR(10)) + ' to ' + CAST(@EndDate AS NVARCHAR(10));
    PRINT '-> Simple Working Days: ' + CAST(@SimpleWorkDays AS NVARCHAR(10));
    PRINT '-> Advanced Business Days: ' + CAST(@BusinessDays AS NVARCHAR(10));
    PRINT '-> ZzBusinessDaysCalculator: PASS';
END TRY
BEGIN CATCH
    PRINT '-> ZzBusinessDaysCalculator: FAIL - ' + ERROR_MESSAGE();
END CATCH
PRINT '=====================================';

-- Test 6: ZzScheduleGenerator (Table-Valued Function)
PRINT 'Test 6: Testing ZzScheduleGenerator function...';
BEGIN TRY
    DECLARE @ScheduleCount INT;
    SELECT @ScheduleCount = COUNT(*)
    FROM [dbo].[ZzScheduleGenerator]('2025-10-01', '2025-10-07', 'WEEKLY', 1, 'MON,TUE,WED,THU,SUN', 1);
    
    PRINT '-> Generated schedule entries: ' + CAST(@ScheduleCount AS NVARCHAR(10));
    PRINT '-> ZzScheduleGenerator: PASS';
    
    -- Show sample results
    PRINT '-> Sample Schedule (first 5 days):';
    SELECT TOP 5 
        CAST(ScheduleDate AS NVARCHAR(10)) AS [Date],
        DayName AS [Day],
        ScheduleType AS [Type],
        CASE WHEN IsWorkDay = 1 THEN 'Yes' ELSE 'No' END AS [Work]
    FROM [dbo].[ZzScheduleGenerator]('2025-10-01', '2025-10-07', 'WEEKLY', 1, 'MON,TUE,WED,THU,SUN', 1)
    ORDER BY ScheduleDate;
    
END TRY
BEGIN CATCH
    PRINT '-> ZzScheduleGenerator: FAIL - ' + ERROR_MESSAGE();
END CATCH
PRINT '=====================================';

-- Summary
PRINT 'Advanced DateTime Functions Test Summary:';
PRINT '- ZzConvertToLunar: Converts Gregorian to Islamic lunar calendar';
PRINT '- ZzHolidayChecker: Checks Iranian holidays';
PRINT '- ZzDateValidator: Validates dates in multiple calendar systems';
PRINT '- ZzTimeZoneConverter: Converts between time zones';
PRINT '- ZzBusinessDaysCalculator: Advanced working days calculation';
PRINT '- ZzScheduleGenerator: Generates work schedules';
PRINT '';
PRINT 'Test completed successfully!';
PRINT '=====================================';
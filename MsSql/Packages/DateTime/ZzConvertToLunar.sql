-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-30
-- Description:	Converts a Gregorian date to Islamic lunar calendar (Hijri) with proper calculation.
-- Sample:		SELECT [dbo].[ZzConvertToLunar]('2025-09-30');
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[ZzConvertToLunar](@gregorianDate DATE)
RETURNS NVARCHAR(10)
AS
BEGIN
    -- Islamic calendar epoch: July 16, 622 CE (Gregorian)
    DECLARE @IslamicEpoch DATE = '622-07-16';
    DECLARE @DaysSinceEpoch INT;
    DECLARE @LunarYear INT;
    DECLARE @LunarMonth INT;
    DECLARE @LunarDay INT;
    DECLARE @DaysInYear INT;
    DECLARE @DaysInMonth INT;
    DECLARE @TotalDays INT;
    
    -- Calculate days since Islamic epoch
    SET @DaysSinceEpoch = DATEDIFF(DAY, @IslamicEpoch, @gregorianDate);
    
    -- Average lunar year is approximately 354.37 days
    SET @LunarYear = 1 + (@DaysSinceEpoch / 354);
    SET @TotalDays = @DaysSinceEpoch;
    
    -- Calculate exact year by subtracting full years
    WHILE @TotalDays >= 0
    BEGIN
        -- Leap year pattern: years 2,5,7,10,13,16,18,21,24,26,29 in 30-year cycle
        SET @DaysInYear = CASE 
            WHEN (@LunarYear % 30) IN (2,5,7,10,13,16,18,21,24,26,29) THEN 355
            ELSE 354
        END;
        
        IF @TotalDays >= @DaysInYear
        BEGIN
            SET @TotalDays = @TotalDays - @DaysInYear;
            SET @LunarYear = @LunarYear + 1;
        END
        ELSE
            BREAK;
    END
    
    -- Calculate month and day
    SET @LunarMonth = 1;
    WHILE @TotalDays >= 0 AND @LunarMonth <= 12
    BEGIN
        -- Months alternate between 30 and 29 days, with Dhul-Hijjah having 30 in leap years
        SET @DaysInMonth = CASE
            WHEN @LunarMonth IN (1,3,5,7,9,11) THEN 30
            WHEN @LunarMonth IN (2,4,6,8,10) THEN 29
            WHEN @LunarMonth = 12 AND (@LunarYear % 30) IN (2,5,7,10,13,16,18,21,24,26,29) THEN 30
            ELSE 29
        END;
        
        IF @TotalDays >= @DaysInMonth
        BEGIN
            SET @TotalDays = @TotalDays - @DaysInMonth;
            SET @LunarMonth = @LunarMonth + 1;
        END
        ELSE
            BREAK;
    END
    
    SET @LunarDay = @TotalDays + 1;
    
    RETURN FORMAT(@LunarYear, '0000') + '/' + 
           FORMAT(@LunarMonth, '00') + '/' + 
           FORMAT(@LunarDay, '00');
END
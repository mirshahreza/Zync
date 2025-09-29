-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-30
-- Description:	Advanced business days calculator with Iranian holidays support.
-- Sample:		SELECT [dbo].[ZzBusinessDaysCalculator]('2025-03-20','2025-03-25', 'IR');
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[ZzBusinessDaysCalculator] (
    @startDate DATE, 
    @endDate DATE, 
    @countryCode NVARCHAR(10) = 'IR'
)
RETURNS INT
AS
BEGIN
    DECLARE @businessDays INT = 0;
    DECLARE @currentDate DATE = @startDate;
    DECLARE @dayOfWeek INT;
    
    -- Base working days calculation (excludes Fri/Sat for Iran)
    WHILE @currentDate <= @endDate
    BEGIN
        SET @dayOfWeek = DATEPART(WEEKDAY, @currentDate);
        
        -- For Iran: Friday=6, Saturday=7 are weekends
        IF @countryCode = 'IR' AND @dayOfWeek NOT IN (6, 7)
        BEGIN
            -- Check if it's not a holiday
            IF dbo.ZzHolidayChecker(@currentDate, @countryCode) = 0
                SET @businessDays = @businessDays + 1;
        END
        -- For other countries: Saturday=7, Sunday=1 are weekends  
        ELSE IF @countryCode != 'IR' AND @dayOfWeek NOT IN (7, 1)
        BEGIN
            IF dbo.ZzHolidayChecker(@currentDate, @countryCode) = 0
                SET @businessDays = @businessDays + 1;
        END
        
        SET @currentDate = DATEADD(DAY, 1, @currentDate);
    END
    
    RETURN @businessDays;
END
-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-30
-- Description:	Validates dates in different calendar systems (Gregorian, Shamsi, Hijri).
-- Sample:		SELECT [dbo].[ZzDateValidator]('1404/01/15', 'SHAMSI');
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[ZzDateValidator] (
    @inputDate NVARCHAR(20),
    @calendarType NVARCHAR(10) = 'GREGORIAN' -- GREGORIAN, SHAMSI, HIJRI
)
RETURNS BIT
AS
BEGIN
    DECLARE @isValid BIT = 0;
    DECLARE @year INT, @month INT, @day INT;
    DECLARE @maxDay INT;
    
    -- Check basic format (yyyy/mm/dd or yyyy-mm-dd)
    IF LEN(@inputDate) < 8 OR LEN(@inputDate) > 10
        RETURN 0;
    
    -- Replace separators and extract parts
    DECLARE @cleanDate NVARCHAR(20) = REPLACE(REPLACE(@inputDate, '-', '/'), '.', '/');
    DECLARE @parts TABLE (PartIndex INT, PartValue NVARCHAR(10));
    
    -- Simple split by '/'
    INSERT INTO @parts VALUES 
        (1, SUBSTRING(@cleanDate, 1, CHARINDEX('/', @cleanDate) - 1)),
        (2, SUBSTRING(@cleanDate, CHARINDEX('/', @cleanDate) + 1, 
             CHARINDEX('/', @cleanDate, CHARINDEX('/', @cleanDate) + 1) - CHARINDEX('/', @cleanDate) - 1)),
        (3, SUBSTRING(@cleanDate, CHARINDEX('/', @cleanDate, CHARINDEX('/', @cleanDate) + 1) + 1, 20));
    
    -- Validate numeric parts
    SELECT @year = CAST(PartValue AS INT) FROM @parts WHERE PartIndex = 1;
    SELECT @month = CAST(PartValue AS INT) FROM @parts WHERE PartIndex = 2;
    SELECT @day = CAST(PartValue AS INT) FROM @parts WHERE PartIndex = 3;
    
    IF @year IS NULL OR @month IS NULL OR @day IS NULL
        RETURN 0;
    
    -- Validate based on calendar type
    IF @calendarType = 'GREGORIAN'
    BEGIN
        -- Gregorian calendar validation
        IF @year < 1 OR @year > 9999 OR @month < 1 OR @month > 12 OR @day < 1
            RETURN 0;
            
        -- Days in month for Gregorian
        SET @maxDay = CASE @month
            WHEN 2 THEN 
                CASE WHEN (@year % 4 = 0 AND @year % 100 != 0) OR (@year % 400 = 0)
                     THEN 29 ELSE 28 END -- Leap year check
            WHEN 4 THEN 30
            WHEN 6 THEN 30  
            WHEN 9 THEN 30
            WHEN 11 THEN 30
            ELSE 31
        END;
        
        IF @day <= @maxDay
            SET @isValid = 1;
    END
    ELSE IF @calendarType = 'SHAMSI'
    BEGIN
        -- Persian calendar validation  
        IF @year < 1 OR @year > 9999 OR @month < 1 OR @month > 12 OR @day < 1
            RETURN 0;
            
        -- Days in month for Persian calendar
        SET @maxDay = CASE 
            WHEN @month <= 6 THEN 31  -- Farvardin to Shahrivar
            WHEN @month <= 11 THEN 30 -- Mehr to Bahman
            ELSE -- Esfand
                -- Use Gregorian leap year approximation for Esfand length
                CASE WHEN dbo.ZzIsLeapYear(@year) = 1
                     THEN 30 ELSE 29 END
        END;
        
        IF @day <= @maxDay
            SET @isValid = 1;
    END
    ELSE IF @calendarType = 'HIJRI'
    BEGIN
        -- Hijri calendar validation
        IF @year < 1 OR @year > 9999 OR @month < 1 OR @month > 12 OR @day < 1
            RETURN 0;
            
        -- Days in month for Hijri calendar
        SET @maxDay = CASE
            WHEN @month IN (1,3,5,7,9,11) THEN 30
            WHEN @month IN (2,4,6,8,10) THEN 29  
            WHEN @month = 12 THEN
                -- Dhul-Hijjah: 30 days in leap years, 29 in normal years
                CASE WHEN (@year % 30) IN (2,5,7,10,13,16,18,21,24,26,29)
                     THEN 30 ELSE 29 END
            ELSE 29
        END;
        
        IF @day <= @maxDay
            SET @isValid = 1;
    END
    
    RETURN @isValid;
END
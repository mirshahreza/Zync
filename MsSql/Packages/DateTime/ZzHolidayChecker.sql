-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-30
-- Description:	Checks if a given date is an Iranian official holiday.
-- Sample:		SELECT [dbo].[ZzHolidayChecker]('2025-03-21', 'IR');
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[ZzHolidayChecker] (
    @inputDate DATE, 
    @countryCode NVARCHAR(10) = 'IR'
)
RETURNS BIT
AS
BEGIN
    DECLARE @isHoliday BIT = 0;
    DECLARE @month INT = MONTH(@inputDate);
    DECLARE @day INT = DAY(@inputDate);
    DECLARE @year INT = YEAR(@inputDate);
    DECLARE @shamsiDate NVARCHAR(10);
    DECLARE @lunarDate NVARCHAR(10);
    
    IF @countryCode = 'IR'
    BEGIN
        -- Convert to Persian calendar for Persian holidays
        SET @shamsiDate = dbo.ZzConvertToShamsi(@inputDate);
        SET @lunarDate = dbo.ZzConvertToLunar(@inputDate);
        
        DECLARE @shamsiMonth INT = CAST(SUBSTRING(@shamsiDate, 6, 2) AS INT);
        DECLARE @shamsiDay INT = CAST(SUBSTRING(@shamsiDate, 9, 2) AS INT);
        
        DECLARE @lunarMonth INT = CAST(SUBSTRING(@lunarDate, 6, 2) AS INT);
        DECLARE @lunarDay INT = CAST(SUBSTRING(@lunarDate, 9, 2) AS INT);
        
        -- Fixed Persian Calendar Holidays
        IF (@shamsiMonth = 1 AND @shamsiDay BETWEEN 1 AND 4) -- Nowruz (4 days)
           OR (@shamsiMonth = 1 AND @shamsiDay = 12) -- Islamic Republic Day
           OR (@shamsiMonth = 1 AND @shamsiDay = 13) -- Nature Day
           OR (@shamsiMonth = 3 AND @shamsiDay = 14) -- Death of Imam Khomeini
           OR (@shamsiMonth = 3 AND @shamsiDay = 15) -- 15 Khordad Uprising
           OR (@shamsiMonth = 6 AND @shamsiDay = 30) -- Martyrdom of Imam Ali (varies)
           OR (@shamsiMonth = 11 AND @shamsiDay = 22) -- Victory of Islamic Revolution
        BEGIN
            SET @isHoliday = 1;
        END
        
        -- Fixed Lunar Calendar Holidays
        IF (@lunarMonth = 1 AND @lunarDay = 9) -- Tasua
           OR (@lunarMonth = 1 AND @lunarDay = 10) -- Ashura
           OR (@lunarMonth = 2 AND @lunarDay = 20) -- Arbaeen
           OR (@lunarMonth = 2 AND @lunarDay = 28) -- Prophet's Death
           OR (@lunarMonth = 3 AND @lunarDay = 8) -- Imam Hassan's Martyrdom
           OR (@lunarMonth = 3 AND @lunarDay = 17) -- Prophet's Birthday & Imam Sadegh
           OR (@lunarMonth = 6 AND @lunarDay = 3) -- Imam Sadegh's Martyrdom
           OR (@lunarMonth = 7 AND @lunarDay = 13) -- Imam Ali's Birthday
           OR (@lunarMonth = 8 AND @lunarDay = 15) -- Imam Mahdi's Birthday
           OR (@lunarMonth = 9 AND @lunarDay BETWEEN 19 AND 23) -- Laylat al-Qadr (multiple nights)
           OR (@lunarMonth = 10 AND @lunarDay = 1) -- Eid al-Fitr
           OR (@lunarMonth = 10 AND @lunarDay = 2) -- Eid al-Fitr (2nd day)
           OR (@lunarMonth = 12 AND @lunarDay = 10) -- Eid al-Adha
        BEGIN
            SET @isHoliday = 1;
        END
        
        -- International holidays observed in Iran
        IF (@month = 5 AND @day = 1) -- Labor Day
        BEGIN
            SET @isHoliday = 1;
        END
    END
    ELSE IF @countryCode = 'US'
    BEGIN
        -- Sample US holidays (simplified)
        IF (@month = 1 AND @day = 1) -- New Year
           OR (@month = 7 AND @day = 4) -- Independence Day
           OR (@month = 12 AND @day = 25) -- Christmas
        BEGIN
            SET @isHoliday = 1;
        END
    END
    
    RETURN @isHoliday;
END
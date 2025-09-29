-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-30
-- Description:	Converts datetime between different time zones.
-- Sample:		SELECT [dbo].[ZzTimeZoneConverter]('2025-09-30 14:30:00', 'Asia/Tehran', 'UTC');
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[ZzTimeZoneConverter] (
    @inputDateTime DATETIME2,
    @fromTimeZone NVARCHAR(50),
    @toTimeZone NVARCHAR(50)
)
RETURNS DATETIME2
AS
BEGIN
    DECLARE @utcDateTime DATETIME2;
    DECLARE @resultDateTime DATETIME2;
    DECLARE @fromOffset INT = 0; -- Offset in minutes
    DECLARE @toOffset INT = 0;   -- Offset in minutes
    
    -- Define common time zone offsets (in minutes from UTC)
    -- Iran Standard Time (IRST): UTC+3:30 = +210 minutes
    -- Iran Daylight Time (IRDT): UTC+4:30 = +270 minutes (March 22 - September 22)
    IF @fromTimeZone IN ('Asia/Tehran', 'Iran')
    BEGIN
        -- Check if date is in daylight saving period (March 22 - September 22)
        IF (MONTH(@inputDateTime) > 3 OR (MONTH(@inputDateTime) = 3 AND DAY(@inputDateTime) >= 22)) 
           AND (MONTH(@inputDateTime) < 9 OR (MONTH(@inputDateTime) = 9 AND DAY(@inputDateTime) <= 22))
            SET @fromOffset = 270; -- IRDT: UTC+4:30
        ELSE
            SET @fromOffset = 210; -- IRST: UTC+3:30
    END
    ELSE IF @fromTimeZone = 'UTC'
        SET @fromOffset = 0;
    ELSE IF @fromTimeZone IN ('America/New_York', 'EST')
        SET @fromOffset = -300; -- EST: UTC-5 (simplified)
    ELSE IF @fromTimeZone IN ('Europe/London', 'GMT')
        SET @fromOffset = 0; -- GMT: UTC+0 (simplified)
    ELSE IF @fromTimeZone IN ('Asia/Tokyo', 'JST')
        SET @fromOffset = 540; -- JST: UTC+9
    ELSE IF @fromTimeZone IN ('Europe/Berlin', 'CET')
        SET @fromOffset = 60; -- CET: UTC+1 (simplified)
    
    -- Convert to UTC first
    SET @utcDateTime = DATEADD(MINUTE, -@fromOffset, @inputDateTime);
    
    -- Define target time zone offset
    IF @toTimeZone IN ('Asia/Tehran', 'Iran')
    BEGIN
        -- Check if date is in daylight saving period
        IF (MONTH(@utcDateTime) > 3 OR (MONTH(@utcDateTime) = 3 AND DAY(@utcDateTime) >= 22)) 
           AND (MONTH(@utcDateTime) < 9 OR (MONTH(@utcDateTime) = 9 AND DAY(@utcDateTime) <= 22))
            SET @toOffset = 270; -- IRDT: UTC+4:30
        ELSE
            SET @toOffset = 210; -- IRST: UTC+3:30
    END
    ELSE IF @toTimeZone = 'UTC'
        SET @toOffset = 0;
    ELSE IF @toTimeZone IN ('America/New_York', 'EST')
        SET @toOffset = -300; -- EST: UTC-5
    ELSE IF @toTimeZone IN ('Europe/London', 'GMT')
        SET @toOffset = 0; -- GMT: UTC+0
    ELSE IF @toTimeZone IN ('Asia/Tokyo', 'JST')
        SET @toOffset = 540; -- JST: UTC+9
    ELSE IF @toTimeZone IN ('Europe/Berlin', 'CET')
        SET @toOffset = 60; -- CET: UTC+1
    
    -- Convert from UTC to target time zone
    SET @resultDateTime = DATEADD(MINUTE, @toOffset, @utcDateTime);
    
    RETURN @resultDateTime;
END
-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Calculate sunrise and sunset times for given coordinates and date
-- Sample:		SELECT dbo.ZzGetSunriseSunset(35.6892, 51.3890, '2025-01-01')
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzGetSunriseSunset(
    @Latitude FLOAT,
    @Longitude FLOAT,
    @Date DATE
)
RETURNS NVARCHAR(50) -- Returns 'sunrise_time,sunset_time' in HH:MM format
AS
BEGIN
    DECLARE @Result NVARCHAR(50);
    DECLARE @DayOfYear INT;
    DECLARE @Declination FLOAT;
    DECLARE @HourAngle FLOAT;
    DECLARE @SunriseHour FLOAT;
    DECLARE @SunsetHour FLOAT;
    DECLARE @SunriseTime NVARCHAR(10);
    DECLARE @SunsetTime NVARCHAR(10);
    
    -- Calculate day of year
    SET @DayOfYear = DATEPART(DAYOFYEAR, @Date);
    
    -- Calculate solar declination angle (approximation)
    SET @Declination = 23.45 * SIN(RADIANS(360 * (284 + @DayOfYear) / 365.0));
    
    -- Convert to radians
    DECLARE @LatRad FLOAT = RADIANS(@Latitude);
    DECLARE @DecRad FLOAT = RADIANS(@Declination);
    
    -- Calculate hour angle
    DECLARE @CosHourAngle FLOAT = -TAN(@LatRad) * TAN(@DecRad);
    
    -- Check for polar day or polar night
    IF @CosHourAngle < -1.0
    BEGIN
        -- Polar day (sun never sets)
        SET @Result = N'00:00,23:59';
        RETURN @Result;
    END
    ELSE IF @CosHourAngle > 1.0
    BEGIN
        -- Polar night (sun never rises)
        SET @Result = N'--:--,--:--';
        RETURN @Result;
    END
    
    -- Calculate hour angle in degrees
    SET @HourAngle = DEGREES(ACOS(@CosHourAngle));
    
    -- Calculate sunrise and sunset times (in hours from solar noon)
    DECLARE @TimeFromSolarNoon FLOAT = @HourAngle / 15.0; -- Convert degrees to hours
    
    -- Solar noon is approximately at 12:00, adjusted for longitude and time zone
    -- For Iran (UTC+3:30), solar noon varies based on longitude
    DECLARE @SolarNoon FLOAT = 12.0 + (@Longitude - 52.5) / 15.0; -- 52.5° is approx center of Iran
    
    SET @SunriseHour = @SolarNoon - @TimeFromSolarNoon;
    SET @SunsetHour = @SolarNoon + @TimeFromSolarNoon;
    
    -- Ensure times are within 24-hour range
    IF @SunriseHour < 0 SET @SunriseHour = @SunriseHour + 24;
    IF @SunriseHour >= 24 SET @SunriseHour = @SunriseHour - 24;
    IF @SunsetHour < 0 SET @SunsetHour = @SunsetHour + 24;
    IF @SunsetHour >= 24 SET @SunsetHour = @SunsetHour - 24;
    
    -- Convert to HH:MM format
    DECLARE @SunriseHourInt INT = FLOOR(@SunriseHour);
    DECLARE @SunriseMinInt INT = FLOOR((@SunriseHour - @SunriseHourInt) * 60);
    DECLARE @SunsetHourInt INT = FLOOR(@SunsetHour);
    DECLARE @SunsetMinInt INT = FLOOR((@SunsetHour - @SunsetHourInt) * 60);
    
    -- Format times with leading zeros
    SET @SunriseTime = 
        RIGHT('0' + CAST(@SunriseHourInt AS NVARCHAR(2)), 2) + ':' + 
        RIGHT('0' + CAST(@SunriseMinInt AS NVARCHAR(2)), 2);
    
    SET @SunsetTime = 
        RIGHT('0' + CAST(@SunsetHourInt AS NVARCHAR(2)), 2) + ':' + 
        RIGHT('0' + CAST(@SunsetMinInt AS NVARCHAR(2)), 2);
    
    SET @Result = @SunriseTime + ',' + @SunsetTime;
    
    RETURN @Result;
END
GO
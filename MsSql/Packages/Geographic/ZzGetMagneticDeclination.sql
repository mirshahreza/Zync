-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Get magnetic declination (difference between magnetic and true north) for coordinates
-- Sample:		SELECT dbo.ZzGetMagneticDeclination(35.6892, 51.3890, '2025-01-01')
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzGetMagneticDeclination(
    @Latitude FLOAT,
    @Longitude FLOAT,
    @Date DATE
)
RETURNS FLOAT -- Returns declination in degrees (positive = East, negative = West)
AS
BEGIN
    DECLARE @Result FLOAT;
    DECLARE @YearsSince2020 FLOAT;
    DECLARE @BaseDeclination FLOAT;
    DECLARE @AnnualChange FLOAT = 0.1; -- Average annual change for Iran region
    
    -- Calculate years since 2020 (reference year)
    SET @YearsSince2020 = DATEDIFF(DAY, '2020-01-01', @Date) / 365.25;
    
    -- Approximate magnetic declination for different regions of Iran (as of 2020)
    -- These values are based on World Magnetic Model (WMM) approximations
    
    -- Northern Iran (around Tabriz, Ardabil)
    IF @Latitude > 37.0
    BEGIN
        IF @Longitude < 48.0
            SET @BaseDeclination = 4.5; -- Northwest
        ELSE IF @Longitude < 54.0
            SET @BaseDeclination = 4.2; -- North central
        ELSE
            SET @BaseDeclination = 3.8; -- Northeast
    END
    -- Central Iran (around Tehran, Isfahan, Qom)
    ELSE IF @Latitude > 32.0
    BEGIN
        IF @Longitude < 50.0
            SET @BaseDeclination = 3.8; -- Central west
        ELSE IF @Longitude < 55.0
            SET @BaseDeclination = 3.2; -- Central
        ELSE IF @Longitude < 59.0
            SET @BaseDeclination = 2.8; -- Central east
        ELSE
            SET @BaseDeclination = 2.4; -- Far east (Mashhad area)
    END
    -- Southern Iran (around Shiraz, Kerman, Ahvaz)
    ELSE IF @Latitude > 27.0
    BEGIN
        IF @Longitude < 50.0
            SET @BaseDeclination = 3.2; -- Southwest
        ELSE IF @Longitude < 55.0
            SET @BaseDeclination = 2.6; -- South central
        ELSE IF @Longitude < 60.0
            SET @BaseDeclination = 2.0; -- Southeast
        ELSE
            SET @BaseDeclination = 1.6; -- Far southeast (Zahedan area)
    END
    -- Far southern Iran (Bandar Abbas, Persian Gulf islands)
    ELSE
    BEGIN
        IF @Longitude < 55.0
            SET @BaseDeclination = 2.4; -- Persian Gulf west
        ELSE IF @Longitude < 58.0
            SET @BaseDeclination = 1.8; -- Persian Gulf central
        ELSE
            SET @BaseDeclination = 1.4; -- Persian Gulf east
    END
    
    -- Apply annual change (magnetic declination changes over time)
    -- In Iran's region, declination is generally decreasing (moving westward)
    SET @Result = @BaseDeclination - (@AnnualChange * @YearsSince2020);
    
    -- Apply fine adjustments based on longitude for more accuracy
    -- Declination generally decreases as you move east
    DECLARE @LongitudeAdjustment FLOAT = (@Longitude - 52.0) * 0.05; -- 52° is approx center of Iran
    SET @Result = @Result - @LongitudeAdjustment;
    
    -- Apply latitude adjustment
    -- Declination changes with latitude in this region
    DECLARE @LatitudeAdjustment FLOAT = (@Latitude - 32.0) * 0.03; -- 32° is approx center latitude
    SET @Result = @Result + @LatitudeAdjustment;
    
    -- Round to one decimal place for practical use
    SET @Result = ROUND(@Result, 1);
    
    RETURN @Result;
END
GO
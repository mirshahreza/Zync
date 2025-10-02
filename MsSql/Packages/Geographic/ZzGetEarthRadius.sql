-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Get Earth radius based on latitude (considering Earth's oblate shape)
-- Sample:		SELECT dbo.ZzGetEarthRadius(35.6892)
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzGetEarthRadius(
    @Latitude FLOAT -- Latitude in degrees
)
RETURNS FLOAT -- Returns radius in kilometers
AS
BEGIN
    DECLARE @Result FLOAT;
    
    -- Earth's semi-major and semi-minor axes (WGS84)
    DECLARE @A FLOAT = 6378.137; -- Equatorial radius in km
    DECLARE @B FLOAT = 6356.752314245; -- Polar radius in km
    
    -- Convert latitude to radians
    DECLARE @LatRad FLOAT = RADIANS(@Latitude);
    
    -- Calculate radius at given latitude using the formula:
    -- R(φ) = √[(a²cos²φ + b²sin²φ)]
    -- Where φ is latitude, a is equatorial radius, b is polar radius
    
    DECLARE @CosLat FLOAT = COS(@LatRad);
    DECLARE @SinLat FLOAT = SIN(@LatRad);
    
    DECLARE @A2Cos2 FLOAT = @A * @A * @CosLat * @CosLat;
    DECLARE @B2Sin2 FLOAT = @B * @B * @SinLat * @SinLat;
    
    SET @Result = SQRT(@A2Cos2 + @B2Sin2);
    
    RETURN @Result;
END
GO
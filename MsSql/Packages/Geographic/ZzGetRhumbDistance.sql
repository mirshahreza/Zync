-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Calculate Rhumb line distance between two points (constant bearing)
-- Sample:		SELECT [dbo].[ZzGetRhumbDistance](35.6892, 51.3890, 40.7128, -74.0060, 'KM');
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzGetRhumbDistance(
    @lat1 DECIMAL(10,7),
    @lon1 DECIMAL(10,7),
    @lat2 DECIMAL(10,7),
    @lon2 DECIMAL(10,7),
    @unit NVARCHAR(10) = 'KM'
)
RETURNS DECIMAL(15,5)
AS
BEGIN
    DECLARE @result DECIMAL(15,5);
    DECLARE @earth_radius DECIMAL(10,3);
    
    -- Validate coordinates
    IF @lat1 IS NULL OR @lon1 IS NULL OR @lat2 IS NULL OR @lon2 IS NULL
        RETURN NULL;
    
    IF ABS(@lat1) > 90 OR ABS(@lat2) > 90 OR ABS(@lon1) > 180 OR ABS(@lon2) > 180
        RETURN NULL;
    
    -- Set earth radius based on unit
    SET @unit = UPPER(ISNULL(@unit, 'KM'));
    IF @unit = 'MILE' OR @unit = 'MI'
        SET @earth_radius = 3959.0; -- miles
    ELSE
        SET @earth_radius = 6371.0; -- kilometers
    
    -- If same point, return 0
    IF @lat1 = @lat2 AND @lon1 = @lon2
        RETURN 0;
    
    -- Convert degrees to radians
    DECLARE @lat1_rad DECIMAL(15,10) = RADIANS(@lat1);
    DECLARE @lat2_rad DECIMAL(15,10) = RADIANS(@lat2);
    DECLARE @dlon_rad DECIMAL(15,10) = RADIANS(@lon2 - @lon1);
    
    -- Calculate delta latitude
    DECLARE @dlat DECIMAL(15,10) = @lat2_rad - @lat1_rad;
    
    -- Calculate delta psi (mercator projection)
    DECLARE @dpsi DECIMAL(15,10);
    IF ABS(@dlat) < 0.0001 -- Very small latitude difference
        SET @dpsi = COS(@lat1_rad);
    ELSE
        SET @dpsi = @dlat / LOG(TAN(@lat2_rad/2 + PI()/4) / TAN(@lat1_rad/2 + PI()/4));
    
    -- Normalize longitude difference
    IF ABS(@dlon_rad) > PI()
    BEGIN
        IF @dlon_rad > 0
            SET @dlon_rad = -(2 * PI() - @dlon_rad);
        ELSE
            SET @dlon_rad = (2 * PI() + @dlon_rad);
    END
    
    -- Calculate rhumb distance
    DECLARE @distance_ratio DECIMAL(15,10) = SQRT(@dlat * @dlat + @dpsi * @dpsi * @dlon_rad * @dlon_rad);
    SET @result = @distance_ratio * @earth_radius;
    
    RETURN @result;
END
GO
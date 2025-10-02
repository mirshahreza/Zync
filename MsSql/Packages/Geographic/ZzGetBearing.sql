-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Calculate bearing (direction) between two geographic points
-- Sample:		SELECT [dbo].[ZzGetBearing](35.6892, 51.3890, 40.7128, -74.0060);
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzGetBearing(
    @lat1 DECIMAL(10,7),
    @lon1 DECIMAL(10,7),
    @lat2 DECIMAL(10,7),
    @lon2 DECIMAL(10,7)
)
RETURNS DECIMAL(10,5)
AS
BEGIN
    DECLARE @result DECIMAL(10,5);
    
    -- Validate coordinates
    IF @lat1 IS NULL OR @lon1 IS NULL OR @lat2 IS NULL OR @lon2 IS NULL
        RETURN NULL;
    
    IF ABS(@lat1) > 90 OR ABS(@lat2) > 90 OR ABS(@lon1) > 180 OR ABS(@lon2) > 180
        RETURN NULL;
    
    -- Convert degrees to radians
    DECLARE @lat1_rad DECIMAL(15,10) = RADIANS(@lat1);
    DECLARE @lat2_rad DECIMAL(15,10) = RADIANS(@lat2);
    DECLARE @dlon_rad DECIMAL(15,10) = RADIANS(@lon2 - @lon1);
    
    -- Calculate bearing using spherical trigonometry
    DECLARE @y DECIMAL(15,10) = SIN(@dlon_rad) * COS(@lat2_rad);
    DECLARE @x DECIMAL(15,10) = COS(@lat1_rad) * SIN(@lat2_rad) - 
                                SIN(@lat1_rad) * COS(@lat2_rad) * COS(@dlon_rad);
    
    -- Calculate bearing in radians then convert to degrees
    DECLARE @bearing_rad DECIMAL(15,10) = ATN2(@y, @x);
    SET @result = DEGREES(@bearing_rad);
    
    -- Normalize to 0-360 degrees
    IF @result < 0
        SET @result = @result + 360;
    
    RETURN @result;
END
GO
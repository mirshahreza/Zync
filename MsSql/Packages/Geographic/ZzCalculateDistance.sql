-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Calculate distance between two geographic points using Haversine formula
-- Sample:		SELECT [dbo].[ZzCalculateDistance](35.6892, 51.3890, 40.7128, -74.0060, 'KM');
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzCalculateDistance(
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
    DECLARE @lon1_rad DECIMAL(15,10) = RADIANS(@lon1);
    DECLARE @lat2_rad DECIMAL(15,10) = RADIANS(@lat2);
    DECLARE @lon2_rad DECIMAL(15,10) = RADIANS(@lon2);
    
    -- Calculate differences
    DECLARE @dlat DECIMAL(15,10) = @lat2_rad - @lat1_rad;
    DECLARE @dlon DECIMAL(15,10) = @lon2_rad - @lon1_rad;
    
    -- Haversine formula
    DECLARE @a DECIMAL(15,10) = 
        POWER(SIN(@dlat / 2), 2) + 
        COS(@lat1_rad) * COS(@lat2_rad) * POWER(SIN(@dlon / 2), 2);
    
    DECLARE @c DECIMAL(15,10) = 2 * ATN2(SQRT(@a), SQRT(1 - @a));
    
    SET @result = @earth_radius * @c;
    
    RETURN @result;
END
GO
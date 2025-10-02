-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Calculate destination point from start point, bearing, and distance
-- Sample:		SELECT [dbo].[ZzGetDestinationPoint](35.6892, 51.3890, 45, 100, 'KM');
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzGetDestinationPoint(
    @start_lat DECIMAL(10,7),
    @start_lon DECIMAL(10,7),
    @bearing DECIMAL(10,5),
    @distance DECIMAL(15,5),
    @unit NVARCHAR(10) = 'KM'
)
RETURNS NVARCHAR(50)
AS
BEGIN
    DECLARE @result NVARCHAR(50);
    DECLARE @earth_radius DECIMAL(10,3);
    
    -- Validate coordinates
    IF dbo.ZzValidateCoordinates(@start_lat, @start_lon) = 0
        RETURN NULL;
    
    IF @bearing IS NULL OR @distance IS NULL OR @distance < 0
        RETURN NULL;
    
    -- Set earth radius based on unit
    SET @unit = UPPER(ISNULL(@unit, 'KM'));
    IF @unit = 'MILE' OR @unit = 'MI'
        SET @earth_radius = 3959.0; -- miles
    ELSE
        SET @earth_radius = 6371.0; -- kilometers
    
    -- Normalize bearing to 0-360
    WHILE @bearing < 0
        SET @bearing = @bearing + 360;
    WHILE @bearing >= 360
        SET @bearing = @bearing - 360;
    
    -- Convert to radians
    DECLARE @lat1_rad DECIMAL(15,10) = RADIANS(@start_lat);
    DECLARE @lon1_rad DECIMAL(15,10) = RADIANS(@start_lon);
    DECLARE @bearing_rad DECIMAL(15,10) = RADIANS(@bearing);
    DECLARE @distance_ratio DECIMAL(15,10) = @distance / @earth_radius;
    
    -- Calculate destination latitude
    DECLARE @lat2_rad DECIMAL(15,10) = ASIN(
        SIN(@lat1_rad) * COS(@distance_ratio) + 
        COS(@lat1_rad) * SIN(@distance_ratio) * COS(@bearing_rad)
    );
    
    -- Calculate destination longitude
    DECLARE @lon2_rad DECIMAL(15,10) = @lon1_rad + ATN2(
        SIN(@bearing_rad) * SIN(@distance_ratio) * COS(@lat1_rad),
        COS(@distance_ratio) - SIN(@lat1_rad) * SIN(@lat2_rad)
    );
    
    -- Convert back to degrees
    DECLARE @dest_lat DECIMAL(10,7) = DEGREES(@lat2_rad);
    DECLARE @dest_lon DECIMAL(10,7) = DEGREES(@lon2_rad);
    
    -- Normalize longitude to -180 to 180
    WHILE @dest_lon > 180
        SET @dest_lon = @dest_lon - 360;
    WHILE @dest_lon < -180
        SET @dest_lon = @dest_lon + 360;
    
    -- Return as comma-separated string
    SET @result = CAST(@dest_lat AS NVARCHAR(20)) + ',' + CAST(@dest_lon AS NVARCHAR(20));
    
    RETURN @result;
END
GO
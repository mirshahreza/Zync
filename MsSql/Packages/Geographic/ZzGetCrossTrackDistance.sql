-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Calculate cross-track distance from point to great circle path
-- Sample:		SELECT [dbo].[ZzGetCrossTrackDistance](35.7, 51.4, 35.6892, 51.3890, 40.7128, -74.0060, 'KM');
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzGetCrossTrackDistance(
    @point_lat DECIMAL(10,7),
    @point_lon DECIMAL(10,7),
    @path_start_lat DECIMAL(10,7),
    @path_start_lon DECIMAL(10,7),
    @path_end_lat DECIMAL(10,7),
    @path_end_lon DECIMAL(10,7),
    @unit NVARCHAR(10) = 'KM'
)
RETURNS DECIMAL(15,5)
AS
BEGIN
    DECLARE @result DECIMAL(15,5);
    DECLARE @earth_radius DECIMAL(10,3);
    
    -- Validate coordinates
    IF dbo.ZzValidateCoordinates(@point_lat, @point_lon) = 0 OR
       dbo.ZzValidateCoordinates(@path_start_lat, @path_start_lon) = 0 OR
       dbo.ZzValidateCoordinates(@path_end_lat, @path_end_lon) = 0
        RETURN NULL;
    
    -- Set earth radius based on unit
    SET @unit = UPPER(ISNULL(@unit, 'KM'));
    IF @unit = 'MILE' OR @unit = 'MI'
        SET @earth_radius = 3959.0; -- miles
    ELSE
        SET @earth_radius = 6371.0; -- kilometers
    
    -- Calculate distance from path start to point
    DECLARE @distance_start_point DECIMAL(15,5) = dbo.ZzCalculateDistance(
        @path_start_lat, @path_start_lon, @point_lat, @point_lon, @unit
    );
    
    -- Calculate bearing from path start to path end
    DECLARE @path_bearing DECIMAL(10,5) = dbo.ZzGetBearing(
        @path_start_lat, @path_start_lon, @path_end_lat, @path_end_lon
    );
    
    -- Calculate bearing from path start to point
    DECLARE @point_bearing DECIMAL(10,5) = dbo.ZzGetBearing(
        @path_start_lat, @path_start_lon, @point_lat, @point_lon
    );
    
    -- Calculate cross-track distance using formula:
    -- dxt = asin(sin(d13/R) × sin(θ13 - θ12)) × R
    DECLARE @distance_ratio DECIMAL(15,10) = @distance_start_point / @earth_radius;
    DECLARE @bearing_diff_rad DECIMAL(15,10) = RADIANS(@point_bearing - @path_bearing);
    
    DECLARE @cross_track_ratio DECIMAL(15,10) = ASIN(SIN(@distance_ratio) * SIN(@bearing_diff_rad));
    SET @result = ABS(@cross_track_ratio * @earth_radius);
    
    RETURN @result;
END
GO
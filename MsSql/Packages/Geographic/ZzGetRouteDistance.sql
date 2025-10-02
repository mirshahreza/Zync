-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Calculate total distance for multiple waypoints route
-- Sample:		SELECT dbo.ZzGetRouteDistance('35.6892,51.3890;35.7000,51.4000;35.7100,51.4100')
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzGetRouteDistance(
    @Waypoints NVARCHAR(MAX) -- Format: 'lat1,lng1;lat2,lng2;lat3,lng3;...'
)
RETURNS FLOAT -- Returns total distance in kilometers
AS
BEGIN
    DECLARE @TotalDistance FLOAT = 0;
    DECLARE @PointsTable TABLE (
        Latitude FLOAT,
        Longitude FLOAT,
        RowNum INT IDENTITY(1,1)
    );
    
    -- Parse waypoints
    DECLARE @Point NVARCHAR(100);
    
    WHILE CHARINDEX(';', @Waypoints) > 0
    BEGIN
        SET @Point = LEFT(@Waypoints, CHARINDEX(';', @Waypoints) - 1);
        SET @Waypoints = SUBSTRING(@Waypoints, CHARINDEX(';', @Waypoints) + 1, LEN(@Waypoints));
        
        IF CHARINDEX(',', @Point) > 0
        BEGIN
            INSERT INTO @PointsTable (Latitude, Longitude) VALUES (
                CAST(LEFT(@Point, CHARINDEX(',', @Point) - 1) AS FLOAT),
                CAST(SUBSTRING(@Point, CHARINDEX(',', @Point) + 1, LEN(@Point)) AS FLOAT)
            );
        END
    END
    
    -- Add last point
    IF @Waypoints <> '' AND CHARINDEX(',', @Waypoints) > 0
    BEGIN
        INSERT INTO @PointsTable (Latitude, Longitude) VALUES (
            CAST(LEFT(@Waypoints, CHARINDEX(',', @Waypoints) - 1) AS FLOAT),
            CAST(SUBSTRING(@Waypoints, CHARINDEX(',', @Waypoints) + 1, LEN(@Waypoints)) AS FLOAT)
        );
    END
    
    -- Calculate distance between consecutive points using Haversine formula
    DECLARE @i INT = 1;
    DECLARE @PointCount INT = (SELECT COUNT(*) FROM @PointsTable);
    
    WHILE @i < @PointCount
    BEGIN
        DECLARE @Lat1 FLOAT = (SELECT Latitude FROM @PointsTable WHERE RowNum = @i);
        DECLARE @Lng1 FLOAT = (SELECT Longitude FROM @PointsTable WHERE RowNum = @i);
        DECLARE @Lat2 FLOAT = (SELECT Latitude FROM @PointsTable WHERE RowNum = @i + 1);
        DECLARE @Lng2 FLOAT = (SELECT Longitude FROM @PointsTable WHERE RowNum = @i + 1);
        
        -- Haversine formula
        DECLARE @R FLOAT = 6371; -- Earth's radius in km
        DECLARE @dLat FLOAT = RADIANS(@Lat2 - @Lat1);
        DECLARE @dLng FLOAT = RADIANS(@Lng2 - @Lng1);
        DECLARE @a FLOAT = SIN(@dLat/2) * SIN(@dLat/2) + 
                          COS(RADIANS(@Lat1)) * COS(RADIANS(@Lat2)) * 
                          SIN(@dLng/2) * SIN(@dLng/2);
        DECLARE @c FLOAT = 2 * ATN2(SQRT(@a), SQRT(1-@a));
        DECLARE @SegmentDistance FLOAT = @R * @c;
        
        SET @TotalDistance = @TotalDistance + @SegmentDistance;
        SET @i = @i + 1;
    END
    
    RETURN @TotalDistance;
END
GO
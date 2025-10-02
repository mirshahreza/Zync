-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Calculate area of polygon using shoelace formula (in square kilometers)
-- Sample:		SELECT dbo.ZzGetPolygonArea('35.5,51.2;35.7,51.2;35.7,51.5;35.5,51.5')
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzGetPolygonArea(
    @PolygonPoints NVARCHAR(MAX) -- Format: 'lat1,lng1;lat2,lng2;lat3,lng3;...'
)
RETURNS FLOAT
AS
BEGIN
    DECLARE @Result FLOAT = 0;
    DECLARE @PointsTable TABLE (
        Latitude FLOAT,
        Longitude FLOAT,
        RowNum INT
    );
    
    -- Parse polygon points
    DECLARE @Point NVARCHAR(100);
    DECLARE @RowNum INT = 0;
    
    WHILE CHARINDEX(';', @PolygonPoints) > 0
    BEGIN
        SET @Point = LEFT(@PolygonPoints, CHARINDEX(';', @PolygonPoints) - 1);
        SET @PolygonPoints = SUBSTRING(@PolygonPoints, CHARINDEX(';', @PolygonPoints) + 1, LEN(@PolygonPoints));
        
        IF CHARINDEX(',', @Point) > 0
        BEGIN
            SET @RowNum = @RowNum + 1;
            INSERT INTO @PointsTable VALUES (
                CAST(LEFT(@Point, CHARINDEX(',', @Point) - 1) AS FLOAT),
                CAST(SUBSTRING(@Point, CHARINDEX(',', @Point) + 1, LEN(@Point)) AS FLOAT),
                @RowNum
            );
        END
    END
    
    -- Add last point
    IF @PolygonPoints <> '' AND CHARINDEX(',', @PolygonPoints) > 0
    BEGIN
        SET @RowNum = @RowNum + 1;
        INSERT INTO @PointsTable VALUES (
            CAST(LEFT(@PolygonPoints, CHARINDEX(',', @PolygonPoints) - 1) AS FLOAT),
            CAST(SUBSTRING(@PolygonPoints, CHARINDEX(',', @PolygonPoints) + 1, LEN(@PolygonPoints)) AS FLOAT),
            @RowNum
        );
    END
    
    -- Calculate area using shoelace formula
    DECLARE @ShoelaceSum FLOAT = 0;
    DECLARE @i INT = 1;
    DECLARE @j INT;
    DECLARE @TotalPoints INT = (SELECT COUNT(*) FROM @PointsTable);
    
    -- Need at least 3 points for area calculation
    IF @TotalPoints < 3
        RETURN 0;
    
    WHILE @i <= @TotalPoints
    BEGIN
        SET @j = CASE WHEN @i = @TotalPoints THEN 1 ELSE @i + 1 END;
        
        DECLARE @Xi FLOAT = (SELECT Latitude FROM @PointsTable WHERE RowNum = @i);
        DECLARE @Yi FLOAT = (SELECT Longitude FROM @PointsTable WHERE RowNum = @i);
        DECLARE @Xj FLOAT = (SELECT Latitude FROM @PointsTable WHERE RowNum = @j);
        DECLARE @Yj FLOAT = (SELECT Longitude FROM @PointsTable WHERE RowNum = @j);
        
        SET @ShoelaceSum = @ShoelaceSum + (@Xi * @Yj - @Xj * @Yi);
        
        SET @i = @i + 1;
    END
    
    -- Calculate area in square degrees
    DECLARE @AreaDegrees FLOAT = ABS(@ShoelaceSum) / 2.0;
    
    -- Convert to square kilometers (approximate conversion)
    -- 1 degree latitude ≈ 111.32 km
    -- 1 degree longitude varies by latitude, using average
    DECLARE @AvgLatitude FLOAT = (
        SELECT AVG(Latitude) FROM @PointsTable
    );
    DECLARE @LngToKm FLOAT = 111.32 * COS(RADIANS(@AvgLatitude));
    
    SET @Result = @AreaDegrees * 111.32 * @LngToKm;
    
    RETURN @Result;
END
GO
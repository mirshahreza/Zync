-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Calculate centroid (geometric center) of polygon
-- Sample:		SELECT dbo.ZzGetPolygonCenter('35.5,51.2;35.7,51.2;35.7,51.5;35.5,51.5')
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzGetPolygonCenter(
    @PolygonPoints NVARCHAR(MAX) -- Format: 'lat1,lng1;lat2,lng2;lat3,lng3;...'
)
RETURNS NVARCHAR(50) -- Returns 'latitude,longitude'
AS
BEGIN
    DECLARE @Result NVARCHAR(50);
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
    
    -- Calculate centroid using weighted average method
    DECLARE @CentroidLat FLOAT = 0;
    DECLARE @CentroidLng FLOAT = 0;
    DECLARE @Area FLOAT = 0;
    DECLARE @i INT = 1;
    DECLARE @j INT;
    DECLARE @TotalPoints INT = (SELECT COUNT(*) FROM @PointsTable);
    
    -- Need at least 3 points for proper centroid calculation
    IF @TotalPoints < 3
    BEGIN
        -- For 1-2 points, just return average
        SELECT @CentroidLat = AVG(Latitude), @CentroidLng = AVG(Longitude)
        FROM @PointsTable;
        
        SET @Result = CAST(@CentroidLat AS NVARCHAR(20)) + ',' + CAST(@CentroidLng AS NVARCHAR(20));
        RETURN @Result;
    END
    
    WHILE @i <= @TotalPoints
    BEGIN
        SET @j = CASE WHEN @i = @TotalPoints THEN 1 ELSE @i + 1 END;
        
        DECLARE @Xi FLOAT = (SELECT Latitude FROM @PointsTable WHERE RowNum = @i);
        DECLARE @Yi FLOAT = (SELECT Longitude FROM @PointsTable WHERE RowNum = @i);
        DECLARE @Xj FLOAT = (SELECT Latitude FROM @PointsTable WHERE RowNum = @j);
        DECLARE @Yj FLOAT = (SELECT Longitude FROM @PointsTable WHERE RowNum = @j);
        
        DECLARE @CrossProduct FLOAT = (@Xi * @Yj - @Xj * @Yi);
        
        SET @Area = @Area + @CrossProduct;
        SET @CentroidLat = @CentroidLat + (@Xi + @Xj) * @CrossProduct;
        SET @CentroidLng = @CentroidLng + (@Yi + @Yj) * @CrossProduct;
        
        SET @i = @i + 1;
    END
    
    SET @Area = @Area / 2.0;
    
    -- Avoid division by zero
    IF @Area = 0
    BEGIN
        -- Fallback to simple average
        SELECT @CentroidLat = AVG(Latitude), @CentroidLng = AVG(Longitude)
        FROM @PointsTable;
    END
    ELSE
    BEGIN
        SET @CentroidLat = @CentroidLat / (6.0 * @Area);
        SET @CentroidLng = @CentroidLng / (6.0 * @Area);
    END
    
    SET @Result = CAST(@CentroidLat AS NVARCHAR(20)) + ',' + CAST(@CentroidLng AS NVARCHAR(20));
    
    RETURN @Result;
END
GO
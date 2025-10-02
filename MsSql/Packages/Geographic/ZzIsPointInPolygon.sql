-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Check if a point is inside a polygon using ray casting algorithm
-- Sample:		SELECT dbo.ZzIsPointInPolygon(35.6892, 51.3890, '35.5,51.2;35.7,51.2;35.7,51.5;35.5,51.5')
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzIsPointInPolygon(
    @Latitude FLOAT,
    @Longitude FLOAT,
    @PolygonPoints NVARCHAR(MAX) -- Format: 'lat1,lng1;lat2,lng2;lat3,lng3;...'
)
RETURNS BIT
AS
BEGIN
    DECLARE @Result BIT = 0;
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
    
    -- Ray casting algorithm
    DECLARE @CrossingCount INT = 0;
    DECLARE @i INT = 1;
    DECLARE @j INT;
    DECLARE @TotalPoints INT = (SELECT COUNT(*) FROM @PointsTable);
    
    WHILE @i <= @TotalPoints
    BEGIN
        SET @j = CASE WHEN @i = @TotalPoints THEN 1 ELSE @i + 1 END;
        
        DECLARE @Xi FLOAT = (SELECT Latitude FROM @PointsTable WHERE RowNum = @i);
        DECLARE @Yi FLOAT = (SELECT Longitude FROM @PointsTable WHERE RowNum = @i);
        DECLARE @Xj FLOAT = (SELECT Latitude FROM @PointsTable WHERE RowNum = @j);
        DECLARE @Yj FLOAT = (SELECT Longitude FROM @PointsTable WHERE RowNum = @j);
        
        IF ((@Yi > @Longitude) <> (@Yj > @Longitude)) AND
           (@Latitude < (@Xj - @Xi) * (@Longitude - @Yi) / (@Yj - @Yi) + @Xi)
        BEGIN
            SET @CrossingCount = @CrossingCount + 1;
        END
        
        SET @i = @i + 1;
    END
    
    -- Point is inside if crossing count is odd
    SET @Result = CASE WHEN @CrossingCount % 2 = 1 THEN 1 ELSE 0 END;
    
    RETURN @Result;
END
GO
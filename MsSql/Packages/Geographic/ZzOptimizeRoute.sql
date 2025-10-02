-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Optimize route using nearest neighbor algorithm (TSP approximation)
-- Sample:		SELECT dbo.ZzOptimizeRoute('35.6892,51.3890;35.7000,51.4000;35.7100,51.4100', '35.6892,51.3890')
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzOptimizeRoute(
    @Points NVARCHAR(MAX), -- Format: 'lat1,lng1;lat2,lng2;lat3,lng3;...'
    @StartPoint NVARCHAR(50) -- Format: 'lat,lng' - starting point
)
RETURNS NVARCHAR(MAX) -- Returns optimized route as 'lat1,lng1;lat2,lng2;...'
AS
BEGIN
    DECLARE @Result NVARCHAR(MAX) = '';
    DECLARE @PointsTable TABLE (
        Id INT IDENTITY(1,1),
        Latitude FLOAT,
        Longitude FLOAT,
        Visited BIT DEFAULT 0,
        OriginalOrder INT
    );
    
    -- Parse start point
    DECLARE @StartLat FLOAT = CAST(LEFT(@StartPoint, CHARINDEX(',', @StartPoint) - 1) AS FLOAT);
    DECLARE @StartLng FLOAT = CAST(SUBSTRING(@StartPoint, CHARINDEX(',', @StartPoint) + 1, LEN(@StartPoint)) AS FLOAT);
    
    -- Parse points
    DECLARE @Point NVARCHAR(100);
    DECLARE @OrderCounter INT = 1;
    
    WHILE CHARINDEX(';', @Points) > 0
    BEGIN
        SET @Point = LEFT(@Points, CHARINDEX(';', @Points) - 1);
        SET @Points = SUBSTRING(@Points, CHARINDEX(';', @Points) + 1, LEN(@Points));
        
        IF CHARINDEX(',', @Point) > 0
        BEGIN
            INSERT INTO @PointsTable (Latitude, Longitude, OriginalOrder) VALUES (
                CAST(LEFT(@Point, CHARINDEX(',', @Point) - 1) AS FLOAT),
                CAST(SUBSTRING(@Point, CHARINDEX(',', @Point) + 1, LEN(@Point)) AS FLOAT),
                @OrderCounter
            );
            SET @OrderCounter = @OrderCounter + 1;
        END
    END
    
    -- Add last point
    IF @Points <> '' AND CHARINDEX(',', @Points) > 0
    BEGIN
        INSERT INTO @PointsTable (Latitude, Longitude, OriginalOrder) VALUES (
            CAST(LEFT(@Points, CHARINDEX(',', @Points) - 1) AS FLOAT),
            CAST(SUBSTRING(@Points, CHARINDEX(',', @Points) + 1, LEN(@Points)) AS FLOAT),
            @OrderCounter
        );
    END
    
    -- Start building optimized route
    DECLARE @CurrentLat FLOAT = @StartLat;
    DECLARE @CurrentLng FLOAT = @StartLng;
    DECLARE @TotalPoints INT = (SELECT COUNT(*) FROM @PointsTable);
    DECLARE @VisitedCount INT = 0;
    
    -- Add start point to result
    SET @Result = CAST(@StartLat AS NVARCHAR(20)) + ',' + CAST(@StartLng AS NVARCHAR(20));
    
    -- Nearest neighbor algorithm
    WHILE @VisitedCount < @TotalPoints
    BEGIN
        DECLARE @NearestId INT = NULL;
        DECLARE @MinDistance FLOAT = 999999999;
        DECLARE @TempDistance FLOAT;
        
        -- Find nearest unvisited point
        DECLARE point_cursor CURSOR FOR
        SELECT Id, Latitude, Longitude 
        FROM @PointsTable 
        WHERE Visited = 0;
        
        OPEN point_cursor;
        
        DECLARE @Id INT, @Lat FLOAT, @Lng FLOAT;
        
        FETCH NEXT FROM point_cursor INTO @Id, @Lat, @Lng;
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Calculate distance using Haversine formula
            DECLARE @R FLOAT = 6371; -- Earth's radius in km
            DECLARE @dLat FLOAT = RADIANS(@Lat - @CurrentLat);
            DECLARE @dLng FLOAT = RADIANS(@Lng - @CurrentLng);
            DECLARE @a FLOAT = SIN(@dLat/2) * SIN(@dLat/2) + 
                              COS(RADIANS(@CurrentLat)) * COS(RADIANS(@Lat)) * 
                              SIN(@dLng/2) * SIN(@dLng/2);
            DECLARE @c FLOAT = 2 * ATN2(SQRT(@a), SQRT(1-@a));
            SET @TempDistance = @R * @c;
            
            IF @TempDistance < @MinDistance
            BEGIN
                SET @MinDistance = @TempDistance;
                SET @NearestId = @Id;
            END
            
            FETCH NEXT FROM point_cursor INTO @Id, @Lat, @Lng;
        END
        
        CLOSE point_cursor;
        DEALLOCATE point_cursor;
        
        -- Mark nearest point as visited and add to route
        IF @NearestId IS NOT NULL
        BEGIN
            UPDATE @PointsTable SET Visited = 1 WHERE Id = @NearestId;
            
            SELECT @CurrentLat = Latitude, @CurrentLng = Longitude 
            FROM @PointsTable WHERE Id = @NearestId;
            
            SET @Result = @Result + ';' + CAST(@CurrentLat AS NVARCHAR(20)) + ',' + CAST(@CurrentLng AS NVARCHAR(20));
            SET @VisitedCount = @VisitedCount + 1;
        END
        ELSE
            BREAK; -- Safety break
    END
    
    RETURN @Result;
END
GO
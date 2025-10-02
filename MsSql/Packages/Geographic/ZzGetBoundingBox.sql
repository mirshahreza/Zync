-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Get bounding box (min/max coordinates) of a set of points
-- Sample:		SELECT dbo.ZzGetBoundingBox('35.5,51.2;35.7,51.2;35.7,51.5;35.5,51.5')
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzGetBoundingBox(
    @Points NVARCHAR(MAX) -- Format: 'lat1,lng1;lat2,lng2;lat3,lng3;...'
)
RETURNS NVARCHAR(100) -- Returns 'minLat,minLng,maxLat,maxLng'
AS
BEGIN
    DECLARE @Result NVARCHAR(100);
    DECLARE @PointsTable TABLE (
        Latitude FLOAT,
        Longitude FLOAT
    );
    
    -- Parse points
    DECLARE @Point NVARCHAR(100);
    
    WHILE CHARINDEX(';', @Points) > 0
    BEGIN
        SET @Point = LEFT(@Points, CHARINDEX(';', @Points) - 1);
        SET @Points = SUBSTRING(@Points, CHARINDEX(';', @Points) + 1, LEN(@Points));
        
        IF CHARINDEX(',', @Point) > 0
        BEGIN
            INSERT INTO @PointsTable VALUES (
                CAST(LEFT(@Point, CHARINDEX(',', @Point) - 1) AS FLOAT),
                CAST(SUBSTRING(@Point, CHARINDEX(',', @Point) + 1, LEN(@Point)) AS FLOAT)
            );
        END
    END
    
    -- Add last point
    IF @Points <> '' AND CHARINDEX(',', @Points) > 0
    BEGIN
        INSERT INTO @PointsTable VALUES (
            CAST(LEFT(@Points, CHARINDEX(',', @Points) - 1) AS FLOAT),
            CAST(SUBSTRING(@Points, CHARINDEX(',', @Points) + 1, LEN(@Points)) AS FLOAT)
        );
    END
    
    -- Calculate bounding box
    DECLARE @MinLat FLOAT = (SELECT MIN(Latitude) FROM @PointsTable);
    DECLARE @MaxLat FLOAT = (SELECT MAX(Latitude) FROM @PointsTable);
    DECLARE @MinLng FLOAT = (SELECT MIN(Longitude) FROM @PointsTable);
    DECLARE @MaxLng FLOAT = (SELECT MAX(Longitude) FROM @PointsTable);
    
    -- Check if we have valid points
    IF @MinLat IS NULL OR @MaxLat IS NULL OR @MinLng IS NULL OR @MaxLng IS NULL
        RETURN NULL;
    
    SET @Result = 
        CAST(@MinLat AS NVARCHAR(20)) + ',' + 
        CAST(@MinLng AS NVARCHAR(20)) + ',' + 
        CAST(@MaxLat AS NVARCHAR(20)) + ',' + 
        CAST(@MaxLng AS NVARCHAR(20));
    
    RETURN @Result;
END
GO
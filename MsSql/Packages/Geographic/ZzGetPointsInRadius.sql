-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Find all points within a specified radius from a reference point
-- Sample:		SELECT dbo.ZzGetPointsInRadius(35.6892, 51.3890, 10, '35.7000,51.4000;35.7100,51.4100;35.6500,51.3500')
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzGetPointsInRadius(
    @CenterLatitude FLOAT,
    @CenterLongitude FLOAT,
    @RadiusKm FLOAT,
    @Points NVARCHAR(MAX) -- Format: 'lat1,lng1;lat2,lng2;lat3,lng3;...'
)
RETURNS @ResultTable TABLE (
    Latitude FLOAT,
    Longitude FLOAT,
    Distance FLOAT,
    PointString NVARCHAR(50)
)
AS
BEGIN
    -- Parse points and check if they're within radius
    DECLARE @Point NVARCHAR(100);
    
    WHILE CHARINDEX(';', @Points) > 0
    BEGIN
        SET @Point = LEFT(@Points, CHARINDEX(';', @Points) - 1);
        SET @Points = SUBSTRING(@Points, CHARINDEX(';', @Points) + 1, LEN(@Points));
        
        IF CHARINDEX(',', @Point) > 0
        BEGIN
            DECLARE @Lat FLOAT = CAST(LEFT(@Point, CHARINDEX(',', @Point) - 1) AS FLOAT);
            DECLARE @Lng FLOAT = CAST(SUBSTRING(@Point, CHARINDEX(',', @Point) + 1, LEN(@Point)) AS FLOAT);
            
            -- Calculate distance using Haversine formula
            DECLARE @R FLOAT = 6371; -- Earth's radius in km
            DECLARE @dLat FLOAT = RADIANS(@Lat - @CenterLatitude);
            DECLARE @dLng FLOAT = RADIANS(@Lng - @CenterLongitude);
            DECLARE @a FLOAT = SIN(@dLat/2) * SIN(@dLat/2) + 
                              COS(RADIANS(@CenterLatitude)) * COS(RADIANS(@Lat)) * 
                              SIN(@dLng/2) * SIN(@dLng/2);
            DECLARE @c FLOAT = 2 * ATN2(SQRT(@a), SQRT(1-@a));
            DECLARE @Distance FLOAT = @R * @c;
            
            -- Add to result if within radius
            IF @Distance <= @RadiusKm
            BEGIN
                INSERT INTO @ResultTable VALUES (
                    @Lat, 
                    @Lng, 
                    @Distance, 
                    CAST(@Lat AS NVARCHAR(20)) + ',' + CAST(@Lng AS NVARCHAR(20))
                );
            END
        END
    END
    
    -- Check last point
    IF @Points <> '' AND CHARINDEX(',', @Points) > 0
    BEGIN
        SET @Lat = CAST(LEFT(@Points, CHARINDEX(',', @Points) - 1) AS FLOAT);
        SET @Lng = CAST(SUBSTRING(@Points, CHARINDEX(',', @Points) + 1, LEN(@Points)) AS FLOAT);
        
        SET @dLat = RADIANS(@Lat - @CenterLatitude);
        SET @dLng = RADIANS(@Lng - @CenterLongitude);
        SET @a = SIN(@dLat/2) * SIN(@dLat/2) + 
                COS(RADIANS(@CenterLatitude)) * COS(RADIANS(@Lat)) * 
                SIN(@dLng/2) * SIN(@dLng/2);
        SET @c = 2 * ATN2(SQRT(@a), SQRT(1-@a));
        SET @Distance = @R * @c;
        
        IF @Distance <= @RadiusKm
        BEGIN
            INSERT INTO @ResultTable VALUES (
                @Lat, 
                @Lng, 
                @Distance, 
                CAST(@Lat AS NVARCHAR(20)) + ',' + CAST(@Lng AS NVARCHAR(20))
            );
        END
    END
    
    RETURN;
END
GO
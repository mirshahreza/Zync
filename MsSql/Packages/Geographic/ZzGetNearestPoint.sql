-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Find nearest point from a list of points to a reference point
-- Sample:		SELECT dbo.ZzGetNearestPoint(35.6892, 51.3890, '35.7000,51.4000;35.7100,51.4100;35.6500,51.3500')
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzGetNearestPoint(
    @RefLatitude FLOAT,
    @RefLongitude FLOAT,
    @Points NVARCHAR(MAX) -- Format: 'lat1,lng1;lat2,lng2;lat3,lng3;...'
)
RETURNS NVARCHAR(50) -- Returns nearest point as 'latitude,longitude'
AS
BEGIN
    DECLARE @Result NVARCHAR(50) = NULL;
    DECLARE @MinDistance FLOAT = 999999999;
    DECLARE @NearestLat FLOAT;
    DECLARE @NearestLng FLOAT;
    
    -- Parse points and find nearest
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
            DECLARE @dLat FLOAT = RADIANS(@Lat - @RefLatitude);
            DECLARE @dLng FLOAT = RADIANS(@Lng - @RefLongitude);
            DECLARE @a FLOAT = SIN(@dLat/2) * SIN(@dLat/2) + 
                              COS(RADIANS(@RefLatitude)) * COS(RADIANS(@Lat)) * 
                              SIN(@dLng/2) * SIN(@dLng/2);
            DECLARE @c FLOAT = 2 * ATN2(SQRT(@a), SQRT(1-@a));
            DECLARE @Distance FLOAT = @R * @c;
            
            IF @Distance < @MinDistance
            BEGIN
                SET @MinDistance = @Distance;
                SET @NearestLat = @Lat;
                SET @NearestLng = @Lng;
            END
        END
    END
    
    -- Check last point
    IF @Points <> '' AND CHARINDEX(',', @Points) > 0
    BEGIN
        SET @Lat = CAST(LEFT(@Points, CHARINDEX(',', @Points) - 1) AS FLOAT);
        SET @Lng = CAST(SUBSTRING(@Points, CHARINDEX(',', @Points) + 1, LEN(@Points)) AS FLOAT);
        
        SET @dLat = RADIANS(@Lat - @RefLatitude);
        SET @dLng = RADIANS(@Lng - @RefLongitude);
        SET @a = SIN(@dLat/2) * SIN(@dLat/2) + 
                COS(RADIANS(@RefLatitude)) * COS(RADIANS(@Lat)) * 
                SIN(@dLng/2) * SIN(@dLng/2);
        SET @c = 2 * ATN2(SQRT(@a), SQRT(1-@a));
        DECLARE @LastDistance FLOAT = @R * @c;
        
        IF @LastDistance < @MinDistance
        BEGIN
            SET @NearestLat = @Lat;
            SET @NearestLng = @Lng;
        END
    END
    
    -- Format result
    IF @NearestLat IS NOT NULL AND @NearestLng IS NOT NULL
        SET @Result = CAST(@NearestLat AS NVARCHAR(20)) + ',' + CAST(@NearestLng AS NVARCHAR(20));
    
    RETURN @Result;
END
GO
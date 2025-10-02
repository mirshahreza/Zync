-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Check if a point is within specified radius of another point
-- Sample:		SELECT [dbo].[ZzIsPointInRadius](35.6892, 51.3890, 35.7000, 51.4000, 10, 'KM');
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzIsPointInRadius(
    @center_lat DECIMAL(10,7),
    @center_lon DECIMAL(10,7),
    @point_lat DECIMAL(10,7),
    @point_lon DECIMAL(10,7),
    @radius DECIMAL(10,3),
    @unit NVARCHAR(10) = 'KM'
)
RETURNS BIT
AS
BEGIN
    DECLARE @result BIT = 0;
    DECLARE @distance DECIMAL(15,5);
    
    -- Validate inputs
    IF @center_lat IS NULL OR @center_lon IS NULL OR @point_lat IS NULL OR @point_lon IS NULL OR @radius IS NULL
        RETURN 0;
    
    IF @radius < 0
        RETURN 0;
    
    -- Calculate distance between center and point
    SET @distance = dbo.ZzCalculateDistance(@center_lat, @center_lon, @point_lat, @point_lon, @unit);
    
    -- Check if within radius
    IF @distance IS NOT NULL AND @distance <= @radius
        SET @result = 1;
    
    RETURN @result;
END
GO
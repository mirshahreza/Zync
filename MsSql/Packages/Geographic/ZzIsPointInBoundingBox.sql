-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Check if a point is inside a bounding box (rectangle)
-- Sample:		SELECT [dbo].[ZzIsPointInBoundingBox](35.7, 51.4, 35.6, 51.3, 35.8, 51.5);
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzIsPointInBoundingBox(
    @point_lat DECIMAL(10,7),
    @point_lon DECIMAL(10,7),
    @min_lat DECIMAL(10,7),
    @min_lon DECIMAL(10,7),
    @max_lat DECIMAL(10,7),
    @max_lon DECIMAL(10,7)
)
RETURNS BIT
AS
BEGIN
    DECLARE @result BIT = 0;
    
    -- Validate all coordinates
    IF @point_lat IS NULL OR @point_lon IS NULL OR 
       @min_lat IS NULL OR @min_lon IS NULL OR 
       @max_lat IS NULL OR @max_lon IS NULL
        RETURN 0;
    
    -- Validate coordinate ranges
    IF ABS(@point_lat) > 90 OR ABS(@min_lat) > 90 OR ABS(@max_lat) > 90 OR
       ABS(@point_lon) > 180 OR ABS(@min_lon) > 180 OR ABS(@max_lon) > 180
        RETURN 0;
    
    -- Ensure min/max are in correct order
    DECLARE @actual_min_lat DECIMAL(10,7) = CASE WHEN @min_lat <= @max_lat THEN @min_lat ELSE @max_lat END;
    DECLARE @actual_max_lat DECIMAL(10,7) = CASE WHEN @min_lat <= @max_lat THEN @max_lat ELSE @min_lat END;
    DECLARE @actual_min_lon DECIMAL(10,7) = CASE WHEN @min_lon <= @max_lon THEN @min_lon ELSE @max_lon END;
    DECLARE @actual_max_lon DECIMAL(10,7) = CASE WHEN @min_lon <= @max_lon THEN @max_lon ELSE @min_lon END;
    
    -- Check if point is within bounding box
    IF @point_lat >= @actual_min_lat AND @point_lat <= @actual_max_lat AND
       @point_lon >= @actual_min_lon AND @point_lon <= @actual_max_lon
    BEGIN
        SET @result = 1;
    END
    
    RETURN @result;
END
GO
-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Calculate midpoint between two geographic points
-- Sample:		SELECT [dbo].[ZzGetMidpoint](35.6892, 51.3890, 40.7128, -74.0060);
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzGetMidpoint(
    @lat1 DECIMAL(10,7),
    @lon1 DECIMAL(10,7),
    @lat2 DECIMAL(10,7),
    @lon2 DECIMAL(10,7)
)
RETURNS NVARCHAR(50)
AS
BEGIN
    DECLARE @result NVARCHAR(50);
    
    -- Validate coordinates
    IF @lat1 IS NULL OR @lon1 IS NULL OR @lat2 IS NULL OR @lon2 IS NULL
        RETURN NULL;
    
    IF ABS(@lat1) > 90 OR ABS(@lat2) > 90 OR ABS(@lon1) > 180 OR ABS(@lon2) > 180
        RETURN NULL;
    
    -- Convert degrees to radians
    DECLARE @lat1_rad DECIMAL(15,10) = RADIANS(@lat1);
    DECLARE @lon1_rad DECIMAL(15,10) = RADIANS(@lon1);
    DECLARE @lat2_rad DECIMAL(15,10) = RADIANS(@lat2);
    DECLARE @lon2_rad DECIMAL(15,10) = RADIANS(@lon2);
    
    DECLARE @dlon DECIMAL(15,10) = @lon2_rad - @lon1_rad;
    
    -- Calculate midpoint using spherical geometry
    DECLARE @bx DECIMAL(15,10) = COS(@lat2_rad) * COS(@dlon);
    DECLARE @by DECIMAL(15,10) = COS(@lat2_rad) * SIN(@dlon);
    
    DECLARE @lat3_rad DECIMAL(15,10) = ATN2(
        SIN(@lat1_rad) + SIN(@lat2_rad),
        SQRT((COS(@lat1_rad) + @bx) * (COS(@lat1_rad) + @bx) + @by * @by)
    );
    
    DECLARE @lon3_rad DECIMAL(15,10) = @lon1_rad + ATN2(@by, COS(@lat1_rad) + @bx);
    
    -- Convert back to degrees
    DECLARE @mid_lat DECIMAL(10,7) = DEGREES(@lat3_rad);
    DECLARE @mid_lon DECIMAL(10,7) = DEGREES(@lon3_rad);
    
    -- Normalize longitude to -180 to 180
    WHILE @mid_lon > 180
        SET @mid_lon = @mid_lon - 360;
    WHILE @mid_lon < -180
        SET @mid_lon = @mid_lon + 360;
    
    -- Return as comma-separated string
    SET @result = CAST(@mid_lat AS NVARCHAR(20)) + ',' + CAST(@mid_lon AS NVARCHAR(20));
    
    RETURN @result;
END
GO
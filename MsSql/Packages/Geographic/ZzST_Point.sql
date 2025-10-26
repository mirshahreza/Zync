-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-26
-- Description:	Creates a Point geometry from X and Y coordinates (PostGIS-like ST_Point)
-- Sample:		SELECT [dbo].[ZzST_Point](51.3890, 35.6892).ToString();
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzST_Point(
    @x FLOAT,
    @y FLOAT,
    @srid INT = 4326  -- Default to WGS 84 (GPS coordinates)
)
RETURNS GEOMETRY
AS
BEGIN
    DECLARE @point GEOMETRY;
    
    -- Validate inputs
    IF @x IS NULL OR @y IS NULL
        RETURN NULL;
    
    -- Create point geometry
    SET @point = GEOMETRY::Point(@x, @y, @srid);
    
    RETURN @point;
END
GO

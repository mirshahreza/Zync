-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-26
-- Description:	Returns Y coordinate of a Point (PostGIS-like ST_Y)
-- Sample:		SELECT [dbo].[ZzST_Y](geometry::Point(51.3890, 35.6892, 4326));
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzST_Y(
    @geom GEOMETRY
)
RETURNS FLOAT
AS
BEGIN
    IF @geom IS NULL
        RETURN NULL;
    
    -- Check if geometry is a point
    IF @geom.STGeometryType() <> 'Point'
        RETURN NULL;
    
    RETURN @geom.STY;
END
GO

-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-26
-- Description:	Returns first point of a LineString (PostGIS-like ST_StartPoint)
-- Sample:		SELECT [dbo].[ZzST_StartPoint](geometry::STGeomFromText('LINESTRING(0 0, 10 10, 20 20)', 0)).ToString();
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzST_StartPoint(
    @geom GEOMETRY
)
RETURNS GEOMETRY
AS
BEGIN
    IF @geom IS NULL
        RETURN NULL;
    
    -- Check if geometry is a LineString
    IF @geom.STGeometryType() NOT IN ('LineString', 'CircularString')
        RETURN NULL;
    
    RETURN @geom.STStartPoint();
END
GO

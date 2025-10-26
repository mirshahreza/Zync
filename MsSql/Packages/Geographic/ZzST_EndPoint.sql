-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-26
-- Description:	Returns last point of a LineString (PostGIS-like ST_EndPoint)
-- Sample:		SELECT [dbo].[ZzST_EndPoint](geometry::STGeomFromText('LINESTRING(0 0, 10 10, 20 20)', 0)).ToString();
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzST_EndPoint(
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
    
    RETURN @geom.STEndPoint();
END
GO

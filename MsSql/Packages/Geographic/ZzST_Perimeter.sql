-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-26
-- Description:	Calculates 2D perimeter of polygon (PostGIS-like ST_Perimeter)
-- Sample:		SELECT [dbo].[ZzST_Perimeter](geometry::STGeomFromText('POLYGON((0 0, 0 10, 10 10, 10 0, 0 0))', 0));
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzST_Perimeter(
    @geom GEOMETRY
)
RETURNS FLOAT
AS
BEGIN
    IF @geom IS NULL
        RETURN NULL;
    
    -- For polygons, perimeter is the length of the boundary
    DECLARE @geomType NVARCHAR(50) = @geom.STGeometryType();
    
    IF @geomType IN ('Polygon', 'MultiPolygon', 'CurvePolygon')
        RETURN @geom.STBoundary().STLength();
    
    RETURN NULL;
END
GO

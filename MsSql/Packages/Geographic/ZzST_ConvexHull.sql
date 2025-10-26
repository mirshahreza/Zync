-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-26
-- Description:	Computes the convex hull of a geometry (PostGIS-like ST_ConvexHull)
-- Sample:		SELECT [dbo].[ZzST_ConvexHull](geometry::STGeomFromText('MULTIPOINT((0 0), (10 0), (5 10), (5 5))', 0)).ToString();
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzST_ConvexHull(
    @geom GEOMETRY
)
RETURNS GEOMETRY
AS
BEGIN
    IF @geom IS NULL
        RETURN NULL;
    
    RETURN @geom.STConvexHull();
END
GO

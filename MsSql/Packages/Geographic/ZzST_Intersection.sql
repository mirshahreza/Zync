-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-26
-- Description:	Computes geometric intersection (PostGIS-like ST_Intersection)
-- Sample:		SELECT [dbo].[ZzST_Intersection](geometry::STGeomFromText('POLYGON((0 0, 0 10, 10 10, 10 0, 0 0))', 0), geometry::STGeomFromText('POLYGON((5 5, 5 15, 15 15, 15 5, 5 5))', 0)).ToString();
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzST_Intersection(
    @geom1 GEOMETRY,
    @geom2 GEOMETRY
)
RETURNS GEOMETRY
AS
BEGIN
    IF @geom1 IS NULL OR @geom2 IS NULL
        RETURN NULL;
    
    -- Check if geometries have the same SRID
    IF @geom1.STSrid <> @geom2.STSrid
        RETURN NULL;
    
    RETURN @geom1.STIntersection(@geom2);
END
GO

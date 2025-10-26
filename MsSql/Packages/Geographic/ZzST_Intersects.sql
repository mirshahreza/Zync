-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-26
-- Description:	Tests if geometries intersect (PostGIS-like ST_Intersects)
-- Sample:		SELECT [dbo].[ZzST_Intersects](geometry::STGeomFromText('LINESTRING(0 0, 10 10)', 0), geometry::STGeomFromText('LINESTRING(0 10, 10 0)', 0));
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzST_Intersects(
    @geom1 GEOMETRY,
    @geom2 GEOMETRY
)
RETURNS BIT
AS
BEGIN
    IF @geom1 IS NULL OR @geom2 IS NULL
        RETURN 0;
    
    -- Check if geometries have the same SRID
    IF @geom1.STSrid <> @geom2.STSrid
        RETURN 0;
    
    RETURN @geom1.STIntersects(@geom2);
END
GO

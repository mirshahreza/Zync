-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-26
-- Description:	Tests if geometry A is within B (PostGIS-like ST_Within)
-- Sample:		SELECT [dbo].[ZzST_Within](geometry::Point(5, 5, 0), geometry::STGeomFromText('POLYGON((0 0, 0 10, 10 10, 10 0, 0 0))', 0));
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzST_Within(
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
    
    RETURN @geom1.STWithin(@geom2);
END
GO

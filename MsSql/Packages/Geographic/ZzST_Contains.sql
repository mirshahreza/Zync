-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-26
-- Description:	Tests if geometry A contains B (PostGIS-like ST_Contains)
-- Sample:		SELECT [dbo].[ZzST_Contains](geometry::STGeomFromText('POLYGON((0 0, 0 10, 10 10, 10 0, 0 0))', 0), geometry::Point(5, 5, 0));
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzST_Contains(
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
    
    RETURN @geom1.STContains(@geom2);
END
GO

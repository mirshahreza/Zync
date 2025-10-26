-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-26
-- Description:	Returns number of geometries in a collection (PostGIS-like ST_NumGeometries)
-- Sample:		SELECT [dbo].[ZzST_NumGeometries](geometry::STGeomFromText('MULTIPOINT((0 0), (10 10), (20 20))', 0));
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzST_NumGeometries(
    @geom GEOMETRY
)
RETURNS INT
AS
BEGIN
    IF @geom IS NULL
        RETURN NULL;
    
    RETURN @geom.STNumGeometries();
END
GO

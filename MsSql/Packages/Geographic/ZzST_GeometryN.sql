-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-26
-- Description:	Returns Nth geometry in a collection (PostGIS-like ST_GeometryN)
-- Sample:		SELECT [dbo].[ZzST_GeometryN](geometry::STGeomFromText('MULTIPOINT((0 0), (10 10), (20 20))', 0), 2).ToString();
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzST_GeometryN(
    @geom GEOMETRY,
    @n INT
)
RETURNS GEOMETRY
AS
BEGIN
    IF @geom IS NULL OR @n IS NULL
        RETURN NULL;
    
    -- SQL Server uses 1-based indexing, same as PostGIS
    IF @n < 1 OR @n > @geom.STNumGeometries()
        RETURN NULL;
    
    RETURN @geom.STGeometryN(@n);
END
GO

-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-26
-- Description:	Returns Nth point in a LineString (PostGIS-like ST_PointN)
-- Sample:		SELECT [dbo].[ZzST_PointN](geometry::STGeomFromText('LINESTRING(0 0, 10 10, 20 20)', 0), 2).ToString();
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzST_PointN(
    @geom GEOMETRY,
    @n INT
)
RETURNS GEOMETRY
AS
BEGIN
    IF @geom IS NULL OR @n IS NULL
        RETURN NULL;
    
    -- Check if geometry is a LineString
    IF @geom.STGeometryType() NOT IN ('LineString', 'CircularString')
        RETURN NULL;
    
    -- SQL Server uses 1-based indexing, same as PostGIS
    IF @n < 1 OR @n > @geom.STNumPoints()
        RETURN NULL;
    
    RETURN @geom.STPointN(@n);
END
GO

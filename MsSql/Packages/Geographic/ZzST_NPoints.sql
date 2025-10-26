-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-26
-- Description:	Returns number of points in geometry (PostGIS-like ST_NPoints)
-- Sample:		SELECT [dbo].[ZzST_NPoints](geometry::STGeomFromText('LINESTRING(0 0, 10 10, 20 20)', 0));
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzST_NPoints(
    @geom GEOMETRY
)
RETURNS INT
AS
BEGIN
    IF @geom IS NULL
        RETURN NULL;
    
    RETURN @geom.STNumPoints();
END
GO

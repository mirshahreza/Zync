-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-26
-- Description:	Returns point guaranteed to be on surface (PostGIS-like ST_PointOnSurface)
-- Sample:		SELECT [dbo].[ZzST_PointOnSurface](geometry::STGeomFromText('POLYGON((0 0, 0 10, 10 10, 10 0, 0 0))', 0)).ToString();
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzST_PointOnSurface(
    @geom GEOMETRY
)
RETURNS GEOMETRY
AS
BEGIN
    IF @geom IS NULL
        RETURN NULL;
    
    RETURN @geom.STPointOnSurface();
END
GO

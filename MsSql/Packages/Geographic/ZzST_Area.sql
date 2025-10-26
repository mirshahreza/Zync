-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-26
-- Description:	Calculates 2D area of polygon (PostGIS-like ST_Area)
-- Sample:		SELECT [dbo].[ZzST_Area](geometry::STGeomFromText('POLYGON((0 0, 0 10, 10 10, 10 0, 0 0))', 0));
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzST_Area(
    @geom GEOMETRY
)
RETURNS FLOAT
AS
BEGIN
    IF @geom IS NULL
        RETURN NULL;
    
    RETURN @geom.STArea();
END
GO

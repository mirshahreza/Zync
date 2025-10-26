-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-26
-- Description:	Calculates 2D length of LineString (PostGIS-like ST_Length)
-- Sample:		SELECT [dbo].[ZzST_Length](geometry::STGeomFromText('LINESTRING(0 0, 10 10, 20 20)', 0));
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzST_Length(
    @geom GEOMETRY
)
RETURNS FLOAT
AS
BEGIN
    IF @geom IS NULL
        RETURN NULL;
    
    RETURN @geom.STLength();
END
GO

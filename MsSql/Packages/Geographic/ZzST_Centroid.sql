-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-26
-- Description:	Computes geometric center (PostGIS-like ST_Centroid)
-- Sample:		SELECT [dbo].[ZzST_Centroid](geometry::STGeomFromText('POLYGON((0 0, 0 10, 10 10, 10 0, 0 0))', 0)).ToString();
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzST_Centroid(
    @geom GEOMETRY
)
RETURNS GEOMETRY
AS
BEGIN
    IF @geom IS NULL
        RETURN NULL;
    
    RETURN @geom.STCentroid();
END
GO

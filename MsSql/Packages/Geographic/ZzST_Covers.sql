-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-26
-- Description:	Tests if geometry A covers B (PostGIS-like ST_Covers)
-- Sample:		SELECT [dbo].[ZzST_Covers](geometry::STGeomFromText('POLYGON((0 0, 0 10, 10 10, 10 0, 0 0))', 0), geometry::Point(5, 5, 0));
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzST_Covers(
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
    
    -- SQL Server doesn't have STCovers, use combination of Contains and touches
    -- A covers B if A contains B or B is on the boundary of A
    IF @geom1.STContains(@geom2) = 1 OR @geom1.STTouches(@geom2) = 1
        RETURN 1;
    
    RETURN 0;
END
GO

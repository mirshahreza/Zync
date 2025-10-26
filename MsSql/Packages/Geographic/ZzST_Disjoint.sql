-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-26
-- Description:	Tests if geometries are disjoint (PostGIS-like ST_Disjoint)
-- Sample:		SELECT [dbo].[ZzST_Disjoint](geometry::Point(0, 0, 0), geometry::Point(10, 10, 0));
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzST_Disjoint(
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
    
    RETURN @geom1.STDisjoint(@geom2);
END
GO

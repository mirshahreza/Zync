-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-26
-- Description:	Tests if geometries are within distance (PostGIS-like ST_DWithin)
-- Sample:		SELECT [dbo].[ZzST_DWithin](geometry::Point(0, 0, 0), geometry::Point(3, 4, 0), 5);
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzST_DWithin(
    @geom1 GEOMETRY,
    @geom2 GEOMETRY,
    @distance FLOAT
)
RETURNS BIT
AS
BEGIN
    IF @geom1 IS NULL OR @geom2 IS NULL OR @distance IS NULL
        RETURN 0;
    
    -- Check if geometries have the same SRID
    IF @geom1.STSrid <> @geom2.STSrid
        RETURN 0;
    
    IF @geom1.STDistance(@geom2) <= @distance
        RETURN 1;
    
    RETURN 0;
END
GO

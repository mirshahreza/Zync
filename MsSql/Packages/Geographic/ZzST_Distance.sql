-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-26
-- Description:	Calculates minimum distance between geometries (PostGIS-like ST_Distance)
-- Sample:		SELECT [dbo].[ZzST_Distance](geometry::Point(51.3890, 35.6892, 4326), geometry::Point(51.4000, 35.7000, 4326));
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzST_Distance(
    @geom1 GEOMETRY,
    @geom2 GEOMETRY
)
RETURNS FLOAT
AS
BEGIN
    IF @geom1 IS NULL OR @geom2 IS NULL
        RETURN NULL;
    
    -- Check if geometries have the same SRID
    IF @geom1.STSrid <> @geom2.STSrid
        RETURN NULL;
    
    RETURN @geom1.STDistance(@geom2);
END
GO

-- =============================================
-- Author:      Mohsen Mirshahreza
-- Create date: 2025-11-05
-- Description: Calculates geodesic distance (in meters) between two GEOGRAPHY instances (PostGIS-like ST_Distance on geography)
-- Notes:       Uses SQL Server GEOGRAPHY.STDistance which returns meters on WGS 84 (SRID 4326) and other geodetic SRIDs.
--              For inputs created via geography::Point(lat, lon, srid), note the parameter order is (Latitude, Longitude, SRID).
-- Sample:
--   DECLARE @g1 GEOGRAPHY = geography::Point(35.6892, 51.3890, 4326); -- Tehran (lat, lon)
--   DECLARE @g2 GEOGRAPHY = geography::Point(35.7000, 51.4000, 4326);
--   SELECT [dbo].[ZzST_Distance_Meters](@g1, @g2); -- result in meters
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzST_Distance_Meters(
    @geom1 GEOGRAPHY,
    @geom2 GEOGRAPHY
)
RETURNS FLOAT
AS
BEGIN
    IF @geom1 IS NULL OR @geom2 IS NULL
        RETURN NULL;

    -- Ensure both inputs use the same SRID
    IF @geom1.STSrid <> @geom2.STSrid
        RETURN NULL;

    RETURN @geom1.STDistance(@geom2); -- meters for geography
END
GO

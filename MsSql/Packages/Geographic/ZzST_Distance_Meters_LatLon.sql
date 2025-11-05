-- =============================================
-- Author:      Mohsen Mirshahreza
-- Create date: 2025-11-05
-- Description: Geodesic distance in meters from latitude/longitude inputs using GEOGRAPHY
-- Notes:       geography::Point takes (Latitude, Longitude, SRID). Default SRID is 4326 (WGS 84).
-- Sample:
--   SELECT [dbo].[ZzST_Distance_Meters_LatLon](35.6892, 51.3890, 35.7000, 51.4000, 4326);
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzST_Distance_Meters_LatLon(
    @Lat1 FLOAT,
    @Lon1 FLOAT,
    @Lat2 FLOAT,
    @Lon2 FLOAT,
    @SRID INT = 4326
)
RETURNS FLOAT
AS
BEGIN
    IF @Lat1 IS NULL OR @Lon1 IS NULL OR @Lat2 IS NULL OR @Lon2 IS NULL
        RETURN NULL;

    -- Validate latitude/longitude ranges quickly; return NULL if invalid
    IF @Lat1 < -90 OR @Lat1 > 90 OR @Lat2 < -90 OR @Lat2 > 90
        RETURN NULL;
    IF @Lon1 < -180 OR @Lon1 > 180 OR @Lon2 < -180 OR @Lon2 > 180
        RETURN NULL;

    DECLARE @g1 GEOGRAPHY = geography::Point(@Lat1, @Lon1, @SRID);
    DECLARE @g2 GEOGRAPHY = geography::Point(@Lat2, @Lon2, @SRID);

    RETURN @g1.STDistance(@g2); -- meters
END
GO

-- =============================================
-- Author:      Mohsen Mirshahreza
-- Create date: 2025-11-05
-- Description: Convenience stored procedure to compute geodesic distance (meters & kilometers) from lat/lon inputs
-- Notes:       Uses dbo.ZzST_Distance_Meters_LatLon and dbo.ZzConvertDistance for unit conversion.
-- Sample:
--   DECLARE @m FLOAT, @km DECIMAL(15,5);
--   EXEC [dbo].[ZzST_Distance_Meters_Proc]
--        @Lat1 = 35.6892, @Lon1 = 51.3890,
--        @Lat2 = 35.7000, @Lon2 = 51.4000,
--        @Meters = @m OUTPUT, @Kilometers = @km OUTPUT;
--   SELECT @m AS Meters, @km AS Kilometers;
-- =============================================
CREATE OR ALTER PROCEDURE dbo.ZzST_Distance_Meters_Proc
    @Lat1 FLOAT,
    @Lon1 FLOAT,
    @Lat2 FLOAT,
    @Lon2 FLOAT,
    @SRID INT = 4326,
    @Meters FLOAT OUTPUT,
    @Kilometers DECIMAL(15,5) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    SET @Meters = [dbo].[ZzST_Distance_Meters_LatLon](@Lat1, @Lon1, @Lat2, @Lon2, @SRID);
    IF @Meters IS NULL
    BEGIN
        SET @Kilometers = NULL;
        RETURN;
    END

    SET @Kilometers = [dbo].[ZzConvertDistance](@Meters, 'M', 'KM');
END
GO

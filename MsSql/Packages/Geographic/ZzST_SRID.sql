-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-26
-- Description:	Gets SRID (Spatial Reference System ID) of geometry (PostGIS-like ST_SRID)
-- Sample:		SELECT [dbo].[ZzST_SRID](geometry::Point(51.3890, 35.6892, 4326));
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzST_SRID(
    @geom GEOMETRY
)
RETURNS INT
AS
BEGIN
    IF @geom IS NULL
        RETURN NULL;
    
    RETURN @geom.STSrid;
END
GO

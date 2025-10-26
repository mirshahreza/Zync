-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-26
-- Description:	Sets SRID without transforming geometry (PostGIS-like ST_SetSRID)
-- Sample:		SELECT [dbo].[ZzST_SetSRID](geometry::Point(51.3890, 35.6892, 0), 4326).STSrid;
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzST_SetSRID(
    @geom GEOMETRY,
    @srid INT
)
RETURNS GEOMETRY
AS
BEGIN
    DECLARE @result GEOMETRY;
    
    IF @geom IS NULL OR @srid IS NULL
        RETURN NULL;
    
    -- Create WKT and recreate with new SRID
    DECLARE @wkt NVARCHAR(MAX) = @geom.STAsText();
    SET @result = GEOMETRY::STGeomFromText(@wkt, @srid);
    
    RETURN @result;
END
GO

-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-26
-- Description:	Creates a rectangular Polygon from min/max coordinates (PostGIS-like ST_MakeEnvelope)
-- Sample:		SELECT [dbo].[ZzST_MakeEnvelope](51.3890, 35.6892, 51.4100, 35.7100, 4326).ToString();
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzST_MakeEnvelope(
    @xmin FLOAT,
    @ymin FLOAT,
    @xmax FLOAT,
    @ymax FLOAT,
    @srid INT = 4326
)
RETURNS GEOMETRY
AS
BEGIN
    DECLARE @wkt NVARCHAR(MAX);
    
    IF @xmin IS NULL OR @ymin IS NULL OR @xmax IS NULL OR @ymax IS NULL
        RETURN NULL;
    
    -- Create envelope WKT
    SET @wkt = 'POLYGON((' + 
        CAST(@xmin AS NVARCHAR(50)) + ' ' + CAST(@ymin AS NVARCHAR(50)) + ', ' +
        CAST(@xmin AS NVARCHAR(50)) + ' ' + CAST(@ymax AS NVARCHAR(50)) + ', ' +
        CAST(@xmax AS NVARCHAR(50)) + ' ' + CAST(@ymax AS NVARCHAR(50)) + ', ' +
        CAST(@xmax AS NVARCHAR(50)) + ' ' + CAST(@ymin AS NVARCHAR(50)) + ', ' +
        CAST(@xmin AS NVARCHAR(50)) + ' ' + CAST(@ymin AS NVARCHAR(50)) + '))';
    
    RETURN GEOMETRY::STGeomFromText(@wkt, @srid);
END
GO

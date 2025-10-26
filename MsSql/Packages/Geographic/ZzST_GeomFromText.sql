-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-26
-- Description:	Creates geometry from WKT (Well-Known Text) representation (PostGIS-like ST_GeomFromText)
-- Sample:		SELECT [dbo].[ZzST_GeomFromText]('POINT(51.3890 35.6892)', 4326).ToString();
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzST_GeomFromText(
    @wkt NVARCHAR(MAX),
    @srid INT = 4326
)
RETURNS GEOMETRY
AS
BEGIN
    DECLARE @geom GEOMETRY;
    
    IF @wkt IS NULL OR LTRIM(RTRIM(@wkt)) = ''
        RETURN NULL;
    
    BEGIN TRY
        SET @geom = GEOMETRY::STGeomFromText(@wkt, @srid);
    END TRY
    BEGIN CATCH
        RETURN NULL;
    END CATCH
    
    RETURN @geom;
END
GO

-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-26
-- Description:	Creates geometry from WKB (Well-Known Binary) (PostGIS-like ST_GeomFromWKB)
-- Sample:		SELECT [dbo].[ZzST_GeomFromWKB](0x0101000000000000000000F03F0000000000000040, 0).ToString();
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzST_GeomFromWKB(
    @wkb VARBINARY(MAX),
    @srid INT = 4326
)
RETURNS GEOMETRY
AS
BEGIN
    DECLARE @geom GEOMETRY;
    
    IF @wkb IS NULL
        RETURN NULL;
    
    BEGIN TRY
        SET @geom = GEOMETRY::STGeomFromWKB(@wkb, @srid);
    END TRY
    BEGIN CATCH
        RETURN NULL;
    END CATCH
    
    RETURN @geom;
END
GO

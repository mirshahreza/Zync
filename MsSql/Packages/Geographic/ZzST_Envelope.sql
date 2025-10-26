-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-26
-- Description:	Returns bounding box as geometry (PostGIS-like ST_Envelope)
-- Sample:		SELECT [dbo].[ZzST_Envelope](geometry::STGeomFromText('LINESTRING(0 0, 10 10, 20 5)', 0)).ToString();
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzST_Envelope(
    @geom GEOMETRY
)
RETURNS GEOMETRY
AS
BEGIN
    IF @geom IS NULL
        RETURN NULL;
    
    RETURN @geom.STEnvelope();
END
GO

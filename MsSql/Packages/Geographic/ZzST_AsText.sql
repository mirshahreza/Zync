-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-26
-- Description:	Returns WKT (Well-Known Text) representation of geometry (PostGIS-like ST_AsText)
-- Sample:		SELECT [dbo].[ZzST_AsText](geometry::Point(51.3890, 35.6892, 4326));
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzST_AsText(
    @geom GEOMETRY
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    IF @geom IS NULL
        RETURN NULL;
    
    RETURN @geom.STAsText();
END
GO

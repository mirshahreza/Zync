-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-26
-- Description:	Returns WKB (Well-Known Binary) representation of geometry (PostGIS-like ST_AsBinary)
-- Sample:		SELECT [dbo].[ZzST_AsBinary](geometry::Point(51.3890, 35.6892, 4326));
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzST_AsBinary(
    @geom GEOMETRY
)
RETURNS VARBINARY(MAX)
AS
BEGIN
    IF @geom IS NULL
        RETURN NULL;
    
    RETURN @geom.STAsBinary();
END
GO

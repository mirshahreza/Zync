-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-26
-- Description:	Creates a buffer around a geometry (PostGIS-like ST_Buffer)
-- Sample:		SELECT [dbo].[ZzST_Buffer](geometry::Point(51.3890, 35.6892, 4326), 0.01).ToString();
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzST_Buffer(
    @geom GEOMETRY,
    @distance FLOAT
)
RETURNS GEOMETRY
AS
BEGIN
    IF @geom IS NULL OR @distance IS NULL
        RETURN NULL;
    
    RETURN @geom.STBuffer(@distance);
END
GO

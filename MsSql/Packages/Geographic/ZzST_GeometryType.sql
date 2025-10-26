-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-26
-- Description:	Returns the type of geometry (PostGIS-like ST_GeometryType)
-- Sample:		SELECT [dbo].[ZzST_GeometryType](geometry::Point(51.3890, 35.6892, 4326));
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzST_GeometryType(
    @geom GEOMETRY
)
RETURNS NVARCHAR(50)
AS
BEGIN
    IF @geom IS NULL
        RETURN NULL;
    
    -- Return with 'ST_' prefix to match PostGIS format
    RETURN 'ST_' + @geom.STGeometryType();
END
GO

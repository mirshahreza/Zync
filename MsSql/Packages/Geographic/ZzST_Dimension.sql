-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-26
-- Description:	Returns the dimension of geometry (PostGIS-like ST_Dimension)
-- Sample:		SELECT [dbo].[ZzST_Dimension](geometry::STGeomFromText('POLYGON((0 0, 0 10, 10 10, 10 0, 0 0))', 0));
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzST_Dimension(
    @geom GEOMETRY
)
RETURNS INT
AS
BEGIN
    IF @geom IS NULL
        RETURN NULL;
    
    RETURN @geom.STDimension();
END
GO

-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-26
-- Description:	Tests if geometry is empty (PostGIS-like ST_IsEmpty)
-- Sample:		SELECT [dbo].[ZzST_IsEmpty](geometry::STGeomFromText('POINT EMPTY', 0));
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzST_IsEmpty(
    @geom GEOMETRY
)
RETURNS BIT
AS
BEGIN
    IF @geom IS NULL
        RETURN 1;
    
    RETURN @geom.STIsEmpty();
END
GO

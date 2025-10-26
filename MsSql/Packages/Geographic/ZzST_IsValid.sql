-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-26
-- Description:	Tests if geometry is valid (PostGIS-like ST_IsValid)
-- Sample:		SELECT [dbo].[ZzST_IsValid](geometry::Point(51.3890, 35.6892, 4326));
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzST_IsValid(
    @geom GEOMETRY
)
RETURNS BIT
AS
BEGIN
    IF @geom IS NULL
        RETURN 0;
    
    RETURN @geom.STIsValid();
END
GO

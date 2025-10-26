-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-26
-- Description:	Creates a 2D, 3DZ or 4D Point geometry (PostGIS-like ST_MakePoint)
-- Sample:		SELECT [dbo].[ZzST_MakePoint](51.3890, 35.6892, 100, NULL).ToString();
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzST_MakePoint(
    @x FLOAT,
    @y FLOAT,
    @z FLOAT = NULL,
    @m FLOAT = NULL,
    @srid INT = 4326
)
RETURNS GEOMETRY
AS
BEGIN
    DECLARE @point GEOMETRY;
    DECLARE @wkt NVARCHAR(MAX);
    
    -- Validate inputs
    IF @x IS NULL OR @y IS NULL
        RETURN NULL;
    
    -- Build WKT based on dimensions
    IF @z IS NOT NULL AND @m IS NOT NULL
        SET @wkt = 'POINT(' + CAST(@x AS NVARCHAR(50)) + ' ' + CAST(@y AS NVARCHAR(50)) + ' ' + CAST(@z AS NVARCHAR(50)) + ' ' + CAST(@m AS NVARCHAR(50)) + ')';
    ELSE IF @z IS NOT NULL
        SET @wkt = 'POINT(' + CAST(@x AS NVARCHAR(50)) + ' ' + CAST(@y AS NVARCHAR(50)) + ' ' + CAST(@z AS NVARCHAR(50)) + ')';
    ELSE IF @m IS NOT NULL
        SET @wkt = 'POINT M(' + CAST(@x AS NVARCHAR(50)) + ' ' + CAST(@y AS NVARCHAR(50)) + ' ' + CAST(@m AS NVARCHAR(50)) + ')';
    ELSE
        SET @wkt = 'POINT(' + CAST(@x AS NVARCHAR(50)) + ' ' + CAST(@y AS NVARCHAR(50)) + ')';
    
    -- Create point from WKT
    SET @point = GEOMETRY::STGeomFromText(@wkt, @srid);
    
    RETURN @point;
END
GO

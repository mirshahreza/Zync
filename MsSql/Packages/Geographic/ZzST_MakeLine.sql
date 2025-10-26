-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-26
-- Description:	Creates a LineString from Point geometries (PostGIS-like ST_MakeLine)
-- Sample:		SELECT [dbo].[ZzST_MakeLine]('51.3890,35.6892;51.4000,35.7000;51.4100,35.7100', 4326).ToString();
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzST_MakeLine(
    @points NVARCHAR(MAX),  -- Format: 'x1,y1;x2,y2;x3,y3;...'
    @srid INT = 4326
)
RETURNS GEOMETRY
AS
BEGIN
    DECLARE @wkt NVARCHAR(MAX) = 'LINESTRING(';
    DECLARE @point NVARCHAR(100);
    DECLARE @x FLOAT, @y FLOAT;
    DECLARE @pos INT, @commaPos INT;
    
    IF @points IS NULL OR LTRIM(RTRIM(@points)) = ''
        RETURN NULL;
    
    -- Parse points
    DECLARE @pointArray TABLE (Seq INT IDENTITY(1,1), X FLOAT, Y FLOAT);
    
    -- Split by semicolon
    WHILE LEN(@points) > 0
    BEGIN
        SET @pos = CHARINDEX(';', @points);
        IF @pos = 0
            SET @pos = LEN(@points) + 1;
        
        SET @point = LTRIM(RTRIM(SUBSTRING(@points, 1, @pos - 1)));
        
        -- Split by comma
        SET @commaPos = CHARINDEX(',', @point);
        IF @commaPos > 0
        BEGIN
            SET @x = TRY_CAST(SUBSTRING(@point, 1, @commaPos - 1) AS FLOAT);
            SET @y = TRY_CAST(SUBSTRING(@point, @commaPos + 1, LEN(@point)) AS FLOAT);
            
            IF @x IS NOT NULL AND @y IS NOT NULL
                INSERT INTO @pointArray (X, Y) VALUES (@x, @y);
        END
        
        SET @points = SUBSTRING(@points, @pos + 1, LEN(@points));
    END
    
    -- Build WKT
    SELECT @wkt = @wkt + CAST(X AS NVARCHAR(50)) + ' ' + CAST(Y AS NVARCHAR(50)) + ', '
    FROM @pointArray
    ORDER BY Seq;
    
    -- Remove trailing comma and close
    IF LEN(@wkt) > 11
    BEGIN
        SET @wkt = LEFT(@wkt, LEN(@wkt) - 2) + ')';
        RETURN GEOMETRY::STGeomFromText(@wkt, @srid);
    END
    
    RETURN NULL;
END
GO

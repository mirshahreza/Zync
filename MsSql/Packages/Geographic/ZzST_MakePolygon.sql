-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-26
-- Description:	Creates a Polygon from a shell (PostGIS-like ST_MakePolygon)
-- Sample:		SELECT [dbo].[ZzST_MakePolygon]('0,0;0,10;10,10;10,0;0,0', 4326).ToString();
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzST_MakePolygon(
    @shell NVARCHAR(MAX),  -- Format: 'x1,y1;x2,y2;x3,y3;...'
    @srid INT = 4326
)
RETURNS GEOMETRY
AS
BEGIN
    DECLARE @wkt NVARCHAR(MAX) = 'POLYGON((';
    DECLARE @point NVARCHAR(100);
    DECLARE @x FLOAT, @y FLOAT;
    DECLARE @pos INT, @commaPos INT;
    
    IF @shell IS NULL OR LTRIM(RTRIM(@shell)) = ''
        RETURN NULL;
    
    -- Parse points
    DECLARE @pointArray TABLE (Seq INT IDENTITY(1,1), X FLOAT, Y FLOAT);
    
    -- Split by semicolon
    WHILE LEN(@shell) > 0
    BEGIN
        SET @pos = CHARINDEX(';', @shell);
        IF @pos = 0
            SET @pos = LEN(@shell) + 1;
        
        SET @point = LTRIM(RTRIM(SUBSTRING(@shell, 1, @pos - 1)));
        
        -- Split by comma
        SET @commaPos = CHARINDEX(',', @point);
        IF @commaPos > 0
        BEGIN
            SET @x = TRY_CAST(SUBSTRING(@point, 1, @commaPos - 1) AS FLOAT);
            SET @y = TRY_CAST(SUBSTRING(@point, @commaPos + 1, LEN(@point)) AS FLOAT);
            
            IF @x IS NOT NULL AND @y IS NOT NULL
                INSERT INTO @pointArray (X, Y) VALUES (@x, @y);
        END
        
        SET @shell = SUBSTRING(@shell, @pos + 1, LEN(@shell));
    END
    
    -- Build WKT
    SELECT @wkt = @wkt + CAST(X AS NVARCHAR(50)) + ' ' + CAST(Y AS NVARCHAR(50)) + ', '
    FROM @pointArray
    ORDER BY Seq;
    
    -- Remove trailing comma and close
    IF LEN(@wkt) > 10
    BEGIN
        SET @wkt = LEFT(@wkt, LEN(@wkt) - 2) + '))';
        RETURN GEOMETRY::STGeomFromText(@wkt, @srid);
    END
    
    RETURN NULL;
END
GO

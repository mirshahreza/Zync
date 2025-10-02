-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Convert Decimal degrees to Degrees/Minutes/Seconds format
-- Sample:		SELECT [dbo].[ZzConvertDecimalToDMS](35.6892, 'LAT');
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzConvertDecimalToDMS(
    @decimal_degrees DECIMAL(10,7),
    @coordinate_type NVARCHAR(10) = 'LAT'
)
RETURNS NVARCHAR(50)
AS
BEGIN
    DECLARE @result NVARCHAR(50);
    DECLARE @abs_decimal DECIMAL(10,7);
    DECLARE @degrees INT;
    DECLARE @minutes INT;
    DECLARE @seconds DECIMAL(8,4);
    DECLARE @direction NVARCHAR(1);
    
    -- Validate input
    IF @decimal_degrees IS NULL
        RETURN NULL;
    
    SET @coordinate_type = UPPER(ISNULL(@coordinate_type, 'LAT'));
    
    -- Validate coordinate ranges
    IF (@coordinate_type = 'LAT' AND ABS(@decimal_degrees) > 90) OR
       (@coordinate_type = 'LON' AND ABS(@decimal_degrees) > 180)
        RETURN NULL;
    
    -- Determine direction
    IF @coordinate_type = 'LAT'
        SET @direction = CASE WHEN @decimal_degrees >= 0 THEN 'N' ELSE 'S' END;
    ELSE
        SET @direction = CASE WHEN @decimal_degrees >= 0 THEN 'E' ELSE 'W' END;
    
    -- Work with absolute value
    SET @abs_decimal = ABS(@decimal_degrees);
    
    -- Extract degrees
    SET @degrees = FLOOR(@abs_decimal);
    
    -- Extract minutes
    DECLARE @decimal_minutes DECIMAL(10,7) = (@abs_decimal - @degrees) * 60;
    SET @minutes = FLOOR(@decimal_minutes);
    
    -- Extract seconds
    SET @seconds = (@decimal_minutes - @minutes) * 60;
    
    -- Format result
    SET @result = CAST(@degrees AS NVARCHAR(10)) + '°' + 
                  CAST(@minutes AS NVARCHAR(10)) + '′' + 
                  CAST(@seconds AS NVARCHAR(20)) + '″' + @direction;
    
    RETURN @result;
END
GO
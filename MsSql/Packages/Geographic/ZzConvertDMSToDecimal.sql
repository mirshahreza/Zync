-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Convert Degrees/Minutes/Seconds to Decimal degrees
-- Sample:		SELECT [dbo].[ZzConvertDMSToDecimal](35, 41, 21.12, 'N');
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzConvertDMSToDecimal(
    @degrees INT,
    @minutes INT,
    @seconds DECIMAL(8,4),
    @direction NVARCHAR(1)
)
RETURNS DECIMAL(10,7)
AS
BEGIN
    DECLARE @result DECIMAL(10,7);
    
    -- Validate inputs
    IF @degrees IS NULL OR @minutes IS NULL OR @seconds IS NULL OR @direction IS NULL
        RETURN NULL;
    
    IF @degrees < 0 OR @degrees > 180 OR 
       @minutes < 0 OR @minutes >= 60 OR 
       @seconds < 0 OR @seconds >= 60
        RETURN NULL;
    
    SET @direction = UPPER(RTRIM(LTRIM(@direction)));
    IF @direction NOT IN ('N', 'S', 'E', 'W')
        RETURN NULL;
    
    -- Convert to decimal
    SET @result = @degrees + (@minutes / 60.0) + (@seconds / 3600.0);
    
    -- Apply direction (South and West are negative)
    IF @direction IN ('S', 'W')
        SET @result = -@result;
    
    -- Validate result ranges
    IF (@direction IN ('N', 'S') AND ABS(@result) > 90) OR 
       (@direction IN ('E', 'W') AND ABS(@result) > 180)
        RETURN NULL;
    
    RETURN @result;
END
GO
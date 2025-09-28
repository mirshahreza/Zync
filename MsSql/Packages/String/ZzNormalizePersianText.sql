-- =============================================
-- Author:       Zync
-- Create date:  2025-09-29
-- Description:  Normalizes Persian text (Arabic Yeh/Kaf to Persian, trims spaces)
-- Sample:       SELECT [dbo].[ZzNormalizePersianText](N'ك یـک 123');
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[ZzNormalizePersianText] (@s NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    IF @s IS NULL RETURN NULL;
    -- Kaf Arabic (U+0643) -> Kaf Persian (U+06A9)
    SET @s = REPLACE(@s, NCHAR(1603), NCHAR(1705));
    -- Yeh Arabic (U+064A) -> Yeh Persian (U+06CC)
    SET @s = REPLACE(@s, NCHAR(1610), NCHAR(1740));
    -- Tatweel and extra spaces
    SET @s = REPLACE(@s, NCHAR(1600), N'');
    SET @s = LTRIM(RTRIM(@s));
    RETURN @s;
END

-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:  2025-09-29
-- Description:  Converts digits between Persian and English
-- Sample:       SELECT [dbo].[ZzConvertDigitsFaEn](N'۱۲۳abc', 'to-en');
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[ZzConvertDigitsFaEn] (@s NVARCHAR(MAX), @mode VARCHAR(10))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    IF @s IS NULL RETURN NULL;
    DECLARE @i INT = 0;
    WHILE @i <= 9
    BEGIN
        IF @mode = 'to-en'
            SET @s = REPLACE(@s, NCHAR(1776 + @i), NCHAR(48 + @i)); -- ۰..۹ -> 0..9
        ELSE IF @mode = 'to-fa'
            SET @s = REPLACE(@s, NCHAR(48 + @i), NCHAR(1776 + @i)); -- 0..9 -> ۰..۹
        SET @i += 1;
    END
    RETURN @s;
END

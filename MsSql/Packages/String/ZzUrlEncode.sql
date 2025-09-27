-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Encodes a string for safe inclusion in a URL query string.
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzUrlEncode] (@InputString NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @OutputString NVARCHAR(MAX) = '';
    DECLARE @i INT = 1;
    DECLARE @Char NCHAR(1);
    DECLARE @CharCode INT;

    WHILE @i <= LEN(@InputString)
    BEGIN
        SET @Char = SUBSTRING(@InputString, @i, 1);
        SET @CharCode = UNICODE(@Char);

        IF (@CharCode >= 48 AND @CharCode <= 57) OR -- 0-9
           (@CharCode >= 65 AND @CharCode <= 90) OR -- A-Z
           (@CharCode >= 97 AND @CharCode <= 122) OR -- a-z
           @Char IN ('-', '_', '.', '~')
        BEGIN
            SET @OutputString = @OutputString + @Char;
        END
        ELSE
        BEGIN
            SET @OutputString = @OutputString + '%' + RIGHT('00' + CONVERT(NVARCHAR(2), @CharCode, 16), 2);
        END
        SET @i = @i + 1;
    END
    RETURN @OutputString;
END

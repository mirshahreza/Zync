-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Converts a Roman numeral string back into an integer.
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzFromRoman] (@roman VARCHAR(255))
RETURNS INT
AS
BEGIN
    DECLARE @result INT = 0;
    DECLARE @i INT = 1;
    DECLARE @s1 INT, @s2 INT;

    DECLARE @numerals TABLE (Symbol CHAR(1), Value INT);
    INSERT INTO @numerals VALUES ('I', 1), ('V', 5), ('X', 10), ('L', 50), ('C', 100), ('D', 500), ('M', 1000);

    SET @roman = UPPER(@roman);

    WHILE @i <= LEN(@roman)
    BEGIN
        SELECT @s1 = Value FROM @numerals WHERE Symbol = SUBSTRING(@roman, @i, 1);

        IF @i + 1 <= LEN(@roman)
        BEGIN
            SELECT @s2 = Value FROM @numerals WHERE Symbol = SUBSTRING(@roman, @i + 1, 1);
            IF @s1 >= @s2
            BEGIN
                SET @result = @result + @s1;
                SET @i = @i + 1;
            END
            ELSE
            BEGIN
                SET @result = @result + @s2 - @s1;
                SET @i = @i + 2;
            END
        END
        ELSE
        BEGIN
            SET @result = @result + @s1;
            SET @i = @i + 1;
        END
    END

    RETURN @result;
END

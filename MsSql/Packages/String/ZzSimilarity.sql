-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Calculates the Levenshtein distance between two strings.
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzSimilarity]
(
    @s1 NVARCHAR(MAX),
    @s2 NVARCHAR(MAX)
)
RETURNS INT
AS
BEGIN
    DECLARE @s1_len INT = LEN(@s1), @s2_len INT = LEN(@s2);
    DECLARE @i INT, @j INT, @cost INT;
    DECLARE @d TABLE (i INT, j INT, val INT);

    IF @s1_len = 0 RETURN @s2_len;
    IF @s2_len = 0 RETURN @s1_len;

    SET @i = 0;
    WHILE @i <= @s1_len BEGIN
        INSERT @d (i, j, val) VALUES (@i, 0, @i);
        SET @i = @i + 1;
    END

    SET @j = 0;
    WHILE @j <= @s2_len BEGIN
        INSERT @d (i, j, val) VALUES (0, @j, @j);
        SET @j = @j + 1;
    END

    SET @i = 1;
    WHILE @i <= @s1_len BEGIN
        SET @j = 1;
        WHILE @j <= @s2_len BEGIN
            SET @cost = CASE WHEN SUBSTRING(@s1, @i, 1) = SUBSTRING(@s2, @j, 1) THEN 0 ELSE 1 END;
            
            DECLARE @val1 INT, @val2 INT, @val3 INT;
            SELECT @val1 = val FROM @d WHERE i = @i - 1 AND j = @j;
            SELECT @val2 = val FROM @d WHERE i = @i AND j = @j - 1;
            SELECT @val3 = val FROM @d WHERE i = @i - 1 AND j = @j - 1;

            INSERT @d (i, j, val) VALUES (@i, @j, 
                CASE 
                    WHEN @val1 < @val2 AND @val1 < @val3 + @cost THEN @val1 + 1
                    WHEN @val2 < @val1 AND @val2 < @val3 + @cost THEN @val2 + 1
                    ELSE @val3 + @cost
                END);
            SET @j = @j + 1;
        END
        SET @i = @i + 1;
    END

    DECLARE @result INT;
    SELECT @result = val FROM @d WHERE i = @s1_len AND j = @s2_len;
    RETURN @result;
END

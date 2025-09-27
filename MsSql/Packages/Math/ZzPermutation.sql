-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Calculates the number of permutations (nPr).
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzPermutation]
(
    @n INT,
    @r INT
)
RETURNS BIGINT
AS
BEGIN
    IF @r < 0 OR @r > @n
        RETURN 0;

    DECLARE @res BIGINT = 1;
    DECLARE @i INT = 0;
    WHILE @i < @r
    BEGIN
        SET @res = @res * (@n - @i);
        SET @i = @i + 1;
    END

    RETURN @res;
END

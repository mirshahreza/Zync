-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Calculates the number of combinations (nCr).
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzCombination]
(
    @n INT,
    @r INT
)
RETURNS BIGINT
AS
BEGIN
    IF @r < 0 OR @r > @n
        RETURN 0;
    IF @r = 0 OR @r = @n
        RETURN 1;
    IF @r > @n / 2
        SET @r = @n - @r;

    DECLARE @res BIGINT = 1;
    DECLARE @i INT = 1;
    WHILE @i <= @r
    BEGIN
        SET @res = @res * (@n - @i + 1) / @i;
        SET @i = @i + 1;
    END

    RETURN @res;
END

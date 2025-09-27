-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Generates the Nth number in the Fibonacci sequence.
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzFibonacci]
(
    @n INT
)
RETURNS BIGINT
AS
BEGIN
    DECLARE @a BIGINT = 0;
    DECLARE @b BIGINT = 1;
    DECLARE @i INT = 2;
    DECLARE @temp BIGINT;

    IF @n <= 0 RETURN 0;
    IF @n = 1 RETURN 1;

    WHILE @i <= @n
    BEGIN
        SET @temp = @a + @b;
        SET @a = @b;
        SET @b = @temp;
        SET @i = @i + 1;
    END

    RETURN @b;
END

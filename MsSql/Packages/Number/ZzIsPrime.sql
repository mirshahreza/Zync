-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	A function that checks if a given integer is a prime number.
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzIsPrime] (@number INT)
RETURNS BIT
AS
BEGIN
    IF @number <= 1
        RETURN 0;
    IF @number = 2
        RETURN 1;
    IF @number % 2 = 0
        RETURN 0;

    DECLARE @i INT = 3;
    WHILE @i * @i <= @number
    BEGIN
        IF @number % @i = 0
            RETURN 0;
        SET @i = @i + 2;
    END

    RETURN 1;
END

-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Calculates the factorial of a non-negative integer.
-- Sample:
-- SELECT [dbo].[ZzFactorial](5);
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzFactorial] (@number INT)
RETURNS BIGINT
AS
BEGIN
    IF @number < 0
        RETURN NULL; -- Factorial is not defined for negative numbers

    DECLARE @result BIGINT = 1;
    DECLARE @i INT = 1;

    WHILE @i <= @number
    BEGIN
        SET @result = @result * @i;
        SET @i = @i + 1;
    END

    RETURN @result;
END

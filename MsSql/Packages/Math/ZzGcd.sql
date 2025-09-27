-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Finds the greatest common divisor of two integers.
-- Sample:
-- SELECT [dbo].[ZzGcd](48, 18);
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzGcd] (@a INT, @b INT)
RETURNS INT
AS
BEGIN
    DECLARE @temp INT;
    WHILE @b != 0
    BEGIN
        SET @temp = @b;
        SET @b = @a % @b;
        SET @a = @temp;
    END
    RETURN @a;
END

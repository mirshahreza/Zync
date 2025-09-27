CREATE FUNCTION ZzIsLeapYear (@year INT)
RETURNS BIT
AS
BEGIN
    RETURN IIF((@year % 4 = 0 AND @year % 100 != 0) OR (@year % 400 = 0), 1, 0)
END
GO

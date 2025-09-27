-- =============================================
-- Author:		Zync
-- Create date:	2025-09-27
-- Description:	Determines if a year is leap year (Gregorian rules).
-- Sample:		SELECT [dbo].[ZzIsLeapYear](2024);
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[ZzIsLeapYear] (@year INT)
RETURNS BIT
AS
BEGIN
    RETURN IIF((@year % 4 = 0 AND @year % 100 != 0) OR (@year % 400 = 0), 1, 0)
END


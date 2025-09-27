-- =============================================
-- Author:		Zync
-- Create date:	2025-09-27
-- Description:	Returns number of days in specified year and month.
-- Sample:		SELECT [dbo].[ZzDaysInMonth](2025, 2);
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[ZzDaysInMonth] (@year INT, @month INT)
RETURNS INT
AS
BEGIN
    RETURN DAY(EOMONTH(DATEFROMPARTS(@year, @month, 1)))
END


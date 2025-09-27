-- =============================================
-- Author:		Zync
-- Create date:	2025-09-27
-- Description:	Counts working days between two dates (excludes Sat/Sun).
-- Sample:		SELECT [dbo].[ZzWorkingDays]('2025-09-01','2025-09-30');
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[ZzWorkingDays] (@startDate DATE, @endDate DATE)
RETURNS INT
AS
BEGIN
    RETURN (DATEDIFF(dd, @startDate, @endDate) + 1)
          -(DATEDIFF(wk, @startDate, @endDate) * 2)
          -(CASE WHEN DATENAME(dw, @startDate) = 'Sunday' THEN 1 ELSE 0 END)
          -(CASE WHEN DATENAME(dw, @endDate) = 'Saturday' THEN 1 ELSE 0 END)
END


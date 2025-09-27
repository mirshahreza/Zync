CREATE FUNCTION ZzWorkingDays (@startDate DATE, @endDate DATE)
RETURNS INT
AS
BEGIN
    RETURN (DATEDIFF(dd, @startDate, @endDate) + 1)
          -(DATEDIFF(wk, @startDate, @endDate) * 2)
          -(CASE WHEN DATENAME(dw, @startDate) = 'Sunday' THEN 1 ELSE 0 END)
          -(CASE WHEN DATENAME(dw, @endDate) = 'Saturday' THEN 1 ELSE 0 END)
END
GO

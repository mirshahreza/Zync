-- =============================================
-- Author:		Zync
-- Create date:	2025-09-27
-- Description:	Returns the first day of the year for the given date.
-- Sample:		SELECT [dbo].[ZzStartOfYear]('2025-09-27');
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[ZzStartOfYear] (@date DATE)
RETURNS DATE
AS
BEGIN
    RETURN DATEFROMPARTS(YEAR(@date), 1, 1)
END


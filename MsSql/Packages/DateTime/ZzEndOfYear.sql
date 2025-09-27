-- =============================================
-- Author:		Zync
-- Create date:	2025-09-27
-- Description:	Returns the last day of the year for the given date.
-- Sample:		SELECT [dbo].[ZzEndOfYear]('2025-09-27');
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[ZzEndOfYear] (@date DATE)
RETURNS DATE
AS
BEGIN
    RETURN DATEFROMPARTS(YEAR(@date), 12, 31)
END


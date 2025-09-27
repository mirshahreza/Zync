-- =============================================
-- Author:		Zync
-- Create date:	2025-09-27
-- Description:	Returns the first day of the month for the given date.
-- Sample:		SELECT [dbo].[ZzStartOfMonth]('2025-09-27');
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[ZzStartOfMonth] (@date DATE)
RETURNS DATE
AS
BEGIN
    RETURN DATEFROMPARTS(YEAR(@date), MONTH(@date), 1)
END
GO

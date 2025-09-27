-- =============================================
-- Author:		Zync
-- Create date:	2025-09-27
-- Description:	Returns the day number within the year for the given date.
-- Sample:		SELECT [dbo].[ZzDayOfYear]('2025-09-27');
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[ZzDayOfYear] (@date DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEPART(dy, @date)
END
GO

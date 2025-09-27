-- =============================================
-- Author:		Zync
-- Create date:	2025-09-27
-- Description:	Returns the end date of the week for the given date.
-- Sample:		SELECT [dbo].[ZzEndOfWeek]('2025-09-27');
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[ZzEndOfWeek] (@date DATE)
RETURNS DATE
AS
BEGIN
    RETURN DATEADD(wk, DATEDIFF(wk, 7, @date), 12)
END
GO

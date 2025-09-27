-- =============================================
-- Author:		Zync
-- Create date:	2025-09-27
-- Description:	Returns the start date of the week for the given date.
-- Sample:		SELECT [dbo].[ZzStartOfWeek]('2025-09-27');
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[ZzStartOfWeek] (@date DATE)
RETURNS DATE
AS
BEGIN
    RETURN DATEADD(wk, DATEDIFF(wk, 7, @date), 6)
END
GO

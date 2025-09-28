-- =============================================
-- Author:       Zync
-- Create date:  2025-09-29
-- Description:  Returns ISO-8601 week number for a given date
-- Sample:       SELECT [dbo].[ZzISOWeekNumber]('2025-09-29');
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[ZzISOWeekNumber] (@date DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEPART(ISO_WEEK, @date);
END

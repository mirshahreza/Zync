-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-09-27
-- Description:	Returns the ISO-like week number of the given date.
-- Sample:		SELECT [dbo].[ZzWeekOfYear]('2025-09-27');
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[ZzWeekOfYear] (@date DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEPART(wk, @date)
END


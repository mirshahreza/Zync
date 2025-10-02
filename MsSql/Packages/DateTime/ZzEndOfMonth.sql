-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-09-27
-- Description:	Returns the last day of the month for the given date.
-- Sample:		SELECT [dbo].[ZzEndOfMonth]('2025-09-27');
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[ZzEndOfMonth] (@date DATE)
RETURNS DATE
AS
BEGIN
    RETURN EOMONTH(@date)
END


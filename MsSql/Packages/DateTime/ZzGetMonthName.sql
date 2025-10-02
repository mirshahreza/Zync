-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-09-27
-- Description:	Returns localized full month name for given date (en-US).
-- Sample:		SELECT [dbo].[ZzGetMonthName]('2025-09-27');
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[ZzGetMonthName] (@date DATE)
RETURNS NVARCHAR(30)
AS
BEGIN
    RETURN FORMAT(@date, 'MMMM', 'en-US')
END


-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-09-27
-- Description:	Returns the quarter number (1-4) for the given date.
-- Sample:		SELECT [dbo].[ZzQuarter]('2025-09-27');
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[ZzQuarter] (@date DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEPART(qq, @date)
END


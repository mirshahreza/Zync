-- =============================================
-- Author:		Zync
-- Create date:	2025-09-27
-- Description:	Returns the end of the day (23:59:59.997) for the given datetime.
-- Sample:		SELECT [dbo].[ZzEndOfDay](GETDATE());
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[ZzEndOfDay] (@date DATETIME)
RETURNS DATETIME
AS
BEGIN
    RETURN DATEADD(ms, -3, DATEADD(dd, 1, CAST(CAST(@date AS DATE) AS DATETIME)))
END


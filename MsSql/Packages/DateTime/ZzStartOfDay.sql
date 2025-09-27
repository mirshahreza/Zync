-- =============================================
-- Author:		Zync
-- Create date:	2025-09-27
-- Description:	Returns the start of the day (00:00:00.000) for the given datetime.
-- Sample:		SELECT [dbo].[ZzStartOfDay](GETDATE());
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[ZzStartOfDay] (@date DATETIME)
RETURNS DATETIME
AS
BEGIN
    RETURN CAST(CAST(@date AS DATE) AS DATETIME)
END


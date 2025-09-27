-- =============================================
-- Author:		Zync
-- Create date:	2025-09-27
-- Description:	Formats a DATE as yyyy-MM-dd (e.g., 2025-05-04).
-- Sample:		SELECT [dbo].[ZzFormatAsDashedDate]('2025-05-04');
-- =============================================
CREATE OR ALTER FUNCTION [dbo].[ZzFormatAsDashedDate] (@date DATE)
RETURNS CHAR(10)
AS
BEGIN
    RETURN CONVERT(CHAR(10), @date, 23); -- 23 = yyyy-mm-dd
END
GO

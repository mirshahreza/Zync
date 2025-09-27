-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Determines if a number is odd.
-- Sample:
-- SELECT [dbo].[ZzIsOdd](5);
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzIsOdd] (@Number INT)
RETURNS BIT
AS
BEGIN
    RETURN CASE WHEN @Number % 2 <> 0 THEN 1 ELSE 0 END;
END

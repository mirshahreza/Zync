-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Determines if a number is even.
-- Sample:
-- SELECT [dbo].[ZzIsEven](4);
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzIsEven] (@Number INT)
RETURNS BIT
AS
BEGIN
    RETURN CASE WHEN @Number % 2 = 0 THEN 1 ELSE 0 END;
END

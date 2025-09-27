-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Converts an integer to its hexadecimal representation.
-- Sample:
-- SELECT [dbo].[ZzToHex](255);
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzToHex] (@Number INT)
RETURNS VARCHAR(MAX)
AS
BEGIN
    RETURN CONVERT(VARCHAR(MAX), CAST(@Number AS VARBINARY(4)), 2);
END

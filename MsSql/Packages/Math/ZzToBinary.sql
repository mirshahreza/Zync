-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Converts an integer to its binary string representation.
-- Sample:
-- SELECT [dbo].[ZzToBinary](10);
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzToBinary] (@Number INT)
RETURNS VARCHAR(32)
AS
BEGIN
    DECLARE @Binary VARCHAR(32) = '';
    WHILE @Number > 0
    BEGIN
        SET @Binary = CAST(@Number % 2 AS VARCHAR) + @Binary;
        SET @Number = @Number / 2;
    END
    RETURN ISNULL(@Binary, '0');
END

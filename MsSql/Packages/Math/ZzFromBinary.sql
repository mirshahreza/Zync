-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Converts a binary string to its integer representation.
-- Sample:
-- SELECT [dbo].[ZzFromBinary]('1010');
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzFromBinary] (@Binary VARCHAR(32))
RETURNS INT
AS
BEGIN
    DECLARE @Result INT = 0;
    DECLARE @i INT = 1;
    WHILE @i <= LEN(@Binary)
    BEGIN
        SET @Result = @Result * 2 + CAST(SUBSTRING(@Binary, @i, 1) AS INT);
        SET @i = @i + 1;
    END
    RETURN @Result;
END

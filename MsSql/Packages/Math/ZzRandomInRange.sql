-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Generates a random integer within a specified range.
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzRandomInRange] (@LowerBound INT, @UpperBound INT)
RETURNS INT
AS
BEGIN
    RETURN FLOOR(RAND() * (@UpperBound - @LowerBound + 1) + @LowerBound);
END

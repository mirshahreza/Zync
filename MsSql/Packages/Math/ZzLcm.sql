-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Calculates the least common multiple (LCM) of two integers.
-- Sample:
-- SELECT [dbo].[ZzLcm](12, 18);
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzLcm] (@a INT, @b INT)
RETURNS BIGINT
AS
BEGIN
    IF @a = 0 OR @b = 0
        RETURN 0;

    RETURN (CAST(@a AS BIGINT) * @b) / DBO.ZzGcd(@a, @b);
END

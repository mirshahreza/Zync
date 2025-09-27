-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Calculates the specified percentile for a list of numbers.
-- =============================================
-- Note: This function requires a user-defined table type named 'NumberList'.
-- CREATE TYPE NumberList AS TABLE (Value DECIMAL(18, 5));
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzPercentile]
(
    @Numbers dbo.NumberList READONLY,
    @Percentile DECIMAL(5, 2) -- e.g., 0.95 for 95th percentile
)
RETURNS DECIMAL(18, 5)
AS
BEGIN
    DECLARE @Result DECIMAL(18, 5);

    SELECT @Result = PERCENTILE_CONT(@Percentile) WITHIN GROUP (ORDER BY Value) OVER ()
    FROM @Numbers;

    RETURN @Result;
END

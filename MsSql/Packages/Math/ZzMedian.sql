-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Calculates the median value from a list of numbers.
-- =============================================
-- Note: This function requires a user-defined table type named 'NumberList'.
-- You can create it using the following command in its own batch:
-- CREATE TYPE NumberList AS TABLE (Value DECIMAL(18, 5));
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzMedian]
(
    @Numbers dbo.NumberList READONLY
)
RETURNS DECIMAL(18, 5)
AS
BEGIN
    DECLARE @Median DECIMAL(18, 5);

    WITH OrderedNumbers AS (
        SELECT Value,
               ROW_NUMBER() OVER (ORDER BY Value) AS RowNum,
               COUNT(*) OVER () AS Cnt
        FROM @Numbers
    )
    SELECT @Median = AVG(Value)
    FROM OrderedNumbers
    WHERE RowNum IN (FLOOR((Cnt + 1) / 2.0), CEILING((Cnt + 1) / 2.0));

    RETURN @Median;
END

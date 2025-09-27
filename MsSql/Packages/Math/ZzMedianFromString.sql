-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Calculates the median value from a delimited string of numbers.
-- Sample:
-- SELECT [dbo].[ZzMedianFromString]('1,5,2,8,7', ',');
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzMedianFromString]
(
    @NumberString NVARCHAR(MAX),
    @Delimiter CHAR(1) = ','
)
RETURNS DECIMAL(38, 10)
AS
BEGIN
    DECLARE @Numbers TABLE (Value DECIMAL(38, 10));
    INSERT INTO @Numbers (Value)
    SELECT TRY_CAST(Value AS DECIMAL(38, 10))
    FROM STRING_SPLIT(@NumberString, @Delimiter)
    WHERE ISNUMERIC(Value) = 1;

    DECLARE @Median DECIMAL(38, 10);
    
    SELECT @Median = PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Value) OVER ()
    FROM @Numbers;

    RETURN @Median;
END

-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Calculates the standard deviation of a set of numbers from a delimited string.
-- Sample:
-- SELECT [dbo].[ZzStandardDeviation]('1,2,3,4,5', ',');
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzStandardDeviation]
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

    IF (SELECT COUNT(*) FROM @Numbers) < 2
        RETURN 0;

    RETURN (SELECT STDEV(Value) FROM @Numbers);
END

-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Finds the mode (most frequently occurring value) in a delimited string of numbers.
-- Sample:
-- SELECT [dbo].[ZzMode]('1,2,2,3,3,3,4', ',');
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzMode]
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

    DECLARE @Mode DECIMAL(38, 10);

    WITH Counts AS (
        SELECT Value, COUNT(*) AS Frequency
        FROM @Numbers
        GROUP BY Value
    )
    SELECT TOP 1 @Mode = Value
    FROM Counts
    ORDER BY Frequency DESC, Value; -- Add Value to break ties consistently

    RETURN @Mode;
END

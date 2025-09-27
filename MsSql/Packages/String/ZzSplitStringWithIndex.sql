-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Splits a delimited string and returns the index and value of each element.
-- Sample:
-- SELECT * FROM [dbo].[ZzSplitStringWithIndex]('apple,banana,cherry', ',');
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzSplitStringWithIndex]
(
    @String NVARCHAR(MAX),
    @Delimiter CHAR(1)
)
RETURNS @Result TABLE (
    [Index] INT,
    [Value] NVARCHAR(MAX)
)
AS
BEGIN
    WITH Split AS
    (
        SELECT
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS [Index],
            [Value]
        FROM STRING_SPLIT(@String, @Delimiter)
    )
    INSERT INTO @Result ([Index], [Value])
    SELECT [Index], [Value] FROM Split;

    RETURN;
END

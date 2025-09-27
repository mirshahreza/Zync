-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Extracts the portion of a string between two delimiters.
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzSubstringBetween]
(
    @InputString NVARCHAR(MAX),
    @StartDelimiter NVARCHAR(100),
    @EndDelimiter NVARCHAR(100)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @StartPos INT = CHARINDEX(@StartDelimiter, @InputString);
    IF @StartPos = 0
        RETURN NULL;

    SET @StartPos = @StartPos + LEN(@StartDelimiter);
    DECLARE @EndPos INT = CHARINDEX(@EndDelimiter, @InputString, @StartPos);
    IF @EndPos = 0
        RETURN NULL;

    RETURN SUBSTRING(@InputString, @StartPos, @EndPos - @StartPos);
END

-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Counts the number of non-overlapping occurrences of a substring.
-- Sample:
-- SELECT [dbo].[ZzCountSubstring]('ababab', 'ab');
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzCountSubstring]
(
    @InputString NVARCHAR(MAX),
    @Substring NVARCHAR(MAX)
)
RETURNS INT
AS
BEGIN
    IF @Substring IS NULL OR LEN(@Substring) = 0
        RETURN 0;

    RETURN (LEN(@InputString) - LEN(REPLACE(@InputString, @Substring, ''))) / LEN(@Substring);
END

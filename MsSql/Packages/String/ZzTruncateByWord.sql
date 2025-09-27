-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Truncates a string to the last full word before a specified length.
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzTruncateByWord]
(
    @InputString NVARCHAR(MAX),
    @MaxLength INT
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    IF LEN(@InputString) <= @MaxLength
        RETURN @InputString;

    DECLARE @TruncatedString NVARCHAR(MAX) = LEFT(@InputString, @MaxLength);
    DECLARE @LastSpace INT = CHARINDEX(' ', REVERSE(@TruncatedString));

    IF @LastSpace > 0
        RETURN LEFT(@TruncatedString, @MaxLength - @LastSpace);
    
    -- If no space was found, just truncate at the length
    RETURN LEFT(@InputString, @MaxLength);
END

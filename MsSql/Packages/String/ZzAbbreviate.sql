-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Truncates a string to a specified length and appends an ellipsis.
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzAbbreviate]
(
    @InputString NVARCHAR(MAX),
    @MaxLength INT,
    @Ellipsis NVARCHAR(10) = '...'
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    IF LEN(@InputString) <= @MaxLength
        RETURN @InputString;

    RETURN LEFT(@InputString, @MaxLength - LEN(@Ellipsis)) + @Ellipsis;
END

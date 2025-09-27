-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Checks if a string contains any of the substrings from a delimited list.
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzContainsAny]
(
    @InputString NVARCHAR(MAX),
    @SearchTerms NVARCHAR(MAX),
    @Delimiter CHAR(1) = ','
)
RETURNS BIT
AS
BEGIN
    DECLARE @Found BIT = 0;

    SELECT @Found = 1
    FROM STRING_SPLIT(@SearchTerms, @Delimiter)
    WHERE CHARINDEX(LTRIM(RTRIM(Value)), @InputString) > 0;

    RETURN ISNULL(@Found, 0);
END

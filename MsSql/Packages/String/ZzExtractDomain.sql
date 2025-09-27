-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Extracts the domain name from an email address or a URL.
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzExtractDomain] (@InputString NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @Domain NVARCHAR(MAX);
    DECLARE @AtPosition INT = CHARINDEX('@', @InputString);

    IF @AtPosition > 0
    BEGIN
        -- It's an email address
        SET @Domain = SUBSTRING(@InputString, @AtPosition + 1, LEN(@InputString));
    END
    ELSE
    BEGIN
        -- Assume it's a URL
        SET @Domain = REPLACE(REPLACE(@InputString, 'http://', ''), 'https://', '');
        IF CHARINDEX('/', @Domain) > 0
            SET @Domain = LEFT(@Domain, CHARINDEX('/', @Domain) - 1);
        IF CHARINDEX(':', @Domain) > 0
            SET @Domain = LEFT(@Domain, CHARINDEX(':', @Domain) - 1);
    END

    RETURN @Domain;
END

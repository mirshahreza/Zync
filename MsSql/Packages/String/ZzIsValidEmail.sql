-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Performs a structural validation of an email address.
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzIsValidEmail] (@Email NVARCHAR(320))
RETURNS BIT
AS
BEGIN
    IF @Email IS NULL
        RETURN 0;

    -- An email must contain exactly one '@' symbol.
    IF LEN(@Email) - LEN(REPLACE(@Email, '@', '')) <> 1
        RETURN 0;

    -- Must not start or end with '@'.
    IF LEFT(@Email, 1) = '@' OR RIGHT(@Email, 1) = '@'
        RETURN 0;

    -- The local part (before @) must not be empty.
    IF CHARINDEX('@', @Email) = 1
        RETURN 0;

    -- The domain part (after @) must not be empty and must contain at least one dot.
    DECLARE @DomainPart NVARCHAR(320) = SUBSTRING(@Email, CHARINDEX('@', @Email) + 1, LEN(@Email));
    IF LEN(@DomainPart) = 0 OR CHARINDEX('.', @DomainPart) = 0
        RETURN 0;

    -- The domain part must not start or end with a dot.
    IF LEFT(@DomainPart, 1) = '.' OR RIGHT(@DomainPart, 1) = '.'
        RETURN 0;

    -- The domain part must not have consecutive dots.
    IF CHARINDEX('..', @DomainPart) > 0
        RETURN 0;

    -- Check for invalid characters.
    IF @Email LIKE '%[^a-zA-Z0-9@._-]%'
        RETURN 0;

    RETURN 1;
END

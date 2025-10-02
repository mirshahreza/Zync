-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Validate email address format using pattern matching
-- Sample:		SELECT [dbo].[ZzValidateEmail]('user@example.com');
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzValidateEmail(
    @email NVARCHAR(256)
)
RETURNS BIT
AS
BEGIN
    DECLARE @result BIT = 0;
    
    -- Basic validation
    IF @email IS NULL OR LEN(@email) = 0 OR LEN(@email) > 254
        RETURN 0;
    
    -- Check for single @ symbol
    IF LEN(@email) - LEN(REPLACE(@email, '@', '')) != 1
        RETURN 0;
    
    DECLARE @at_pos INT = CHARINDEX('@', @email);
    DECLARE @local_part NVARCHAR(128) = LEFT(@email, @at_pos - 1);
    DECLARE @domain_part NVARCHAR(128) = SUBSTRING(@email, @at_pos + 1, LEN(@email) - @at_pos);
    
    -- Validate local part (before @)
    IF LEN(@local_part) = 0 OR LEN(@local_part) > 64
        RETURN 0;
    
    -- Validate domain part (after @)
    IF LEN(@domain_part) = 0 OR LEN(@domain_part) > 253
        RETURN 0;
    
    -- Check for at least one dot in domain
    IF CHARINDEX('.', @domain_part) = 0
        RETURN 0;
    
    -- Check for valid characters in local part
    IF @local_part LIKE '%[^a-zA-Z0-9._+-]%'
        RETURN 0;
    
    -- Check for valid characters in domain part
    IF @domain_part LIKE '%[^a-zA-Z0-9.-]%'
        RETURN 0;
    
    -- Check for consecutive dots
    IF @email LIKE '%..%'
        RETURN 0;
    
    -- Check for dots at the beginning or end
    IF @local_part LIKE '.%' OR @local_part LIKE '%.' OR @domain_part LIKE '.%' OR @domain_part LIKE '%.'
        RETURN 0;
    
    -- Check domain extension length (at least 2 characters)
    DECLARE @last_dot INT = LEN(@domain_part) - CHARINDEX('.', REVERSE(@domain_part)) + 1;
    IF LEN(@domain_part) - @last_dot < 1
        RETURN 0;
    
    SET @result = 1;
    RETURN @result;
END
GO
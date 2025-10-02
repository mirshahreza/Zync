-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Validate URL format
-- Sample:		SELECT [dbo].[ZzValidateURL]('https://www.example.com');
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzValidateURL(
    @url NVARCHAR(2083)
)
RETURNS BIT
AS
BEGIN
    DECLARE @result BIT = 0;
    
    IF @url IS NULL OR LEN(@url) = 0 OR LEN(@url) > 2083
        RETURN 0;
    
    -- Convert to lowercase for validation
    DECLARE @lower_url NVARCHAR(2083) = LOWER(@url);
    
    -- Must start with http:// or https://
    IF @lower_url NOT LIKE 'http://%' AND @lower_url NOT LIKE 'https://%'
        RETURN 0;
    
    -- Get domain part (after protocol)
    DECLARE @domain_start INT = CASE 
        WHEN @lower_url LIKE 'https://%' THEN 9
        ELSE 8
    END;
    
    DECLARE @remaining NVARCHAR(2075) = SUBSTRING(@url, @domain_start, LEN(@url) - @domain_start + 1);
    
    -- Must have at least domain name
    IF LEN(@remaining) = 0
        RETURN 0;
    
    -- Find first slash (path separator) or end of string
    DECLARE @path_start INT = CHARINDEX('/', @remaining);
    DECLARE @domain NVARCHAR(253);
    
    IF @path_start = 0
        SET @domain = @remaining;
    ELSE
        SET @domain = LEFT(@remaining, @path_start - 1);
    
    -- Domain cannot be empty
    IF LEN(@domain) = 0
        RETURN 0;
    
    -- Check for port number
    DECLARE @port_start INT = CHARINDEX(':', @domain);
    IF @port_start > 0
    BEGIN
        DECLARE @port_part NVARCHAR(10) = SUBSTRING(@domain, @port_start + 1, LEN(@domain) - @port_start);
        SET @domain = LEFT(@domain, @port_start - 1);
        
        -- Port must be numeric and valid range
        IF @port_part NOT LIKE '[0-9]%' OR TRY_CONVERT(INT, @port_part) IS NULL OR 
           TRY_CONVERT(INT, @port_part) < 1 OR TRY_CONVERT(INT, @port_part) > 65535
            RETURN 0;
    END
    
    -- Basic domain validation
    IF @domain LIKE '.%' OR @domain LIKE '%.' OR @domain LIKE '%..%'
        RETURN 0;
    
    -- Must contain at least one dot for domain.extension
    IF CHARINDEX('.', @domain) = 0
        RETURN 0;
    
    -- Check for valid domain characters
    IF @domain LIKE '%[^a-zA-Z0-9.-]%'
        RETURN 0;
    
    SET @result = 1;
    RETURN @result;
END
GO
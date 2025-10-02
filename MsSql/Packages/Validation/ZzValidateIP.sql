-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Validate IP addresses (IPv4 and IPv6)
-- Sample:		SELECT [dbo].[ZzValidateIP]('192.168.1.1', 'IPv4');
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzValidateIP(
    @ip_address NVARCHAR(45),
    @version NVARCHAR(10) = 'IPv4'
)
RETURNS BIT
AS
BEGIN
    DECLARE @result BIT = 0;
    
    IF @ip_address IS NULL OR LEN(@ip_address) = 0
        RETURN 0;
    
    SET @version = UPPER(ISNULL(@version, 'IPv4'));
    
    IF @version = 'IPV4'
    BEGIN
        -- IPv4 validation
        IF LEN(@ip_address) > 15 OR LEN(@ip_address) < 7
            RETURN 0;
        
        -- Check for exactly 3 dots
        IF LEN(@ip_address) - LEN(REPLACE(@ip_address, '.', '')) != 3
            RETURN 0;
        
        -- Split and validate each octet
        DECLARE @octet1 NVARCHAR(3) = PARSENAME(@ip_address, 4);
        DECLARE @octet2 NVARCHAR(3) = PARSENAME(@ip_address, 3);
        DECLARE @octet3 NVARCHAR(3) = PARSENAME(@ip_address, 2);
        DECLARE @octet4 NVARCHAR(3) = PARSENAME(@ip_address, 1);
        
        -- Check if all octets exist and are numeric
        IF @octet1 IS NULL OR @octet2 IS NULL OR @octet3 IS NULL OR @octet4 IS NULL
            RETURN 0;
        
        IF @octet1 NOT LIKE '[0-9]%' OR @octet2 NOT LIKE '[0-9]%' OR 
           @octet3 NOT LIKE '[0-9]%' OR @octet4 NOT LIKE '[0-9]%'
            RETURN 0;
        
        -- Check range 0-255 for each octet
        IF TRY_CONVERT(INT, @octet1) IS NULL OR TRY_CONVERT(INT, @octet1) > 255 OR
           TRY_CONVERT(INT, @octet2) IS NULL OR TRY_CONVERT(INT, @octet2) > 255 OR
           TRY_CONVERT(INT, @octet3) IS NULL OR TRY_CONVERT(INT, @octet3) > 255 OR
           TRY_CONVERT(INT, @octet4) IS NULL OR TRY_CONVERT(INT, @octet4) > 255
            RETURN 0;
        
        -- Check for leading zeros (except for "0")
        IF (@octet1 LIKE '0%' AND LEN(@octet1) > 1) OR
           (@octet2 LIKE '0%' AND LEN(@octet2) > 1) OR
           (@octet3 LIKE '0%' AND LEN(@octet3) > 1) OR
           (@octet4 LIKE '0%' AND LEN(@octet4) > 1)
            RETURN 0;
        
        SET @result = 1;
    END
    ELSE IF @version = 'IPV6'
    BEGIN
        -- IPv6 basic validation (simplified)
        IF LEN(@ip_address) > 39 OR LEN(@ip_address) < 2
            RETURN 0;
        
        -- Check for valid characters (hex digits, colons, double colon)
        IF @ip_address LIKE '%[^0-9A-Fa-f:]%'
            RETURN 0;
        
        -- Check for at most one double colon
        IF LEN(@ip_address) - LEN(REPLACE(@ip_address, '::', '')) > 2
            RETURN 0;
        
        -- Basic format validation (this is simplified)
        SET @result = 1;
    END
    
    RETURN @result;
END
GO
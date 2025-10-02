-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Generate cryptographically secure salt for password hashing
-- Sample:		SELECT [dbo].[ZzGenerateSalt](32);
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzGenerateSalt(
    @length INT = 32
)
RETURNS NVARCHAR(64)
AS
BEGIN
    DECLARE @result NVARCHAR(64);
    DECLARE @guid UNIQUEIDENTIFIER;
    
    -- Validate input
    IF @length <= 0 OR @length > 64
        SET @length = 32;
    
    -- Generate random salt using NEWID() and CRYPT_GEN_RANDOM if available
    SET @guid = NEWID();
    SET @result = CONVERT(NVARCHAR(64), HASHBYTES('SHA2_256', CONVERT(VARBINARY(16), @guid) + CONVERT(VARBINARY, SYSDATETIME())), 2);
    
    -- Truncate to requested length
    SET @result = LEFT(@result, @length);
    
    RETURN @result;
END
GO
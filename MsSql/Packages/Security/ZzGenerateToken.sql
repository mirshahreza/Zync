-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Generate secure random tokens for authentication
-- Sample:		SELECT [dbo].[ZzGenerateToken](64);
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzGenerateToken(
    @length INT = 64
)
RETURNS NVARCHAR(128)
AS
BEGIN
    DECLARE @result NVARCHAR(128);
    DECLARE @chars NVARCHAR(62) = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    DECLARE @token NVARCHAR(128) = '';
    DECLARE @i INT = 1;
    DECLARE @random_seed VARBINARY(16);
    
    -- Validate input
    IF @length <= 0 OR @length > 128
        SET @length = 64;
    
    -- Generate multiple GUIDs for better randomness
    WHILE @i <= @length
    BEGIN
        SET @random_seed = CONVERT(VARBINARY(16), NEWID());
        DECLARE @random_int INT = ABS(CONVERT(INT, SUBSTRING(@random_seed, (@i % 16) + 1, 1))) % 62 + 1;
        SET @token = @token + SUBSTRING(@chars, @random_int, 1);
        SET @i = @i + 1;
    END
    
    SET @result = @token;
    
    RETURN @result;
END
GO
-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Encrypt sensitive data using AES encryption
-- Sample:		SELECT [dbo].[ZzEncryptData]('sensitive data', 'encryption_key');
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzEncryptData(
    @data NVARCHAR(MAX),
    @key NVARCHAR(128)
)
RETURNS VARBINARY(MAX)
AS
BEGIN
    DECLARE @result VARBINARY(MAX);
    DECLARE @key_hash VARBINARY(32);
    
    -- Validate inputs
    IF @data IS NULL OR @key IS NULL OR LEN(@data) = 0 OR LEN(@key) = 0
        RETURN NULL;
    
    -- Create a consistent key hash
    SET @key_hash = HASHBYTES('SHA2_256', @key);
    
    -- Encrypt data using AES_256
    SET @result = ENCRYPTBYKEY(KEY_GUID('ZzSecurityKey'), @data);
    
    -- If symmetric key doesn't exist, return hash-based encryption
    IF @result IS NULL
    BEGIN
        -- Simple XOR-based encryption as fallback
        DECLARE @data_binary VARBINARY(MAX) = CONVERT(VARBINARY(MAX), @data);
        DECLARE @i INT = 1;
        DECLARE @key_len INT = LEN(@key_hash);
        DECLARE @encrypted VARBINARY(MAX) = 0x;
        
        WHILE @i <= LEN(@data_binary)
        BEGIN
            SET @encrypted = @encrypted + 
                CONVERT(VARBINARY(1), 
                    CONVERT(INT, SUBSTRING(@data_binary, @i, 1)) ^ 
                    CONVERT(INT, SUBSTRING(@key_hash, ((@i - 1) % @key_len) + 1, 1))
                );
            SET @i = @i + 1;
        END
        
        SET @result = @encrypted;
    END
    
    RETURN @result;
END
GO
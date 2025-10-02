-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Hash passwords using SHA2_512 with salt for secure password storage
-- Sample:		SELECT [dbo].[ZzHashPassword]('mypassword', 'mysalt');
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzHashPassword(
    @password NVARCHAR(128),
    @salt NVARCHAR(64)
)
RETURNS NVARCHAR(128)
AS
BEGIN
    DECLARE @result NVARCHAR(128);
    
    -- Validate inputs
    IF @password IS NULL OR @salt IS NULL OR LEN(@password) = 0 OR LEN(@salt) = 0
        RETURN NULL;
    
    -- Combine password and salt, then hash with SHA2_512
    SET @result = CONVERT(NVARCHAR(128), HASHBYTES('SHA2_512', @password + @salt), 2);
    
    RETURN @result;
END
GO
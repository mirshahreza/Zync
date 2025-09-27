-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Generates a random string of a specified length.
-- Sample:
-- SELECT [dbo].[ZzGenerateRandomString](10, 'ABCDEFG');
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzGenerateRandomString]
(
    @Length INT,
    @CharSet NVARCHAR(255) = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @RandomString NVARCHAR(MAX) = '';
    DECLARE @i INT = 0;
    DECLARE @CharSetLength INT = LEN(@CharSet);

    WHILE @i < @Length
    BEGIN
        DECLARE @Rand FLOAT = (SELECT Value FROM DBO.ZzRandom);
        DECLARE @RandomIndex INT = FLOOR(@Rand * @CharSetLength) + 1;
        SET @RandomString = @RandomString + SUBSTRING(@CharSet, @RandomIndex, 1);
        SET @i = @i + 1;
    END

    RETURN @RandomString;
END

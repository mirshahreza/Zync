-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Converts a string to "Proper Case" (or "Title Case").
-- Sample:
-- SELECT [dbo].[ZzProperCase]('the quick brown fox');
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzProperCase] (@InputText NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @OutputText NVARCHAR(MAX) = LOWER(@InputText);
    DECLARE @i INT = 1;
    DECLARE @IsFirstLetter BIT = 1;

    WHILE @i <= LEN(@OutputText)
    BEGIN
        DECLARE @Char NCHAR(1) = SUBSTRING(@OutputText, @i, 1);
        IF @IsFirstLetter = 1 AND @Char LIKE '[a-z]'
        BEGIN
            SET @OutputText = STUFF(@OutputText, @i, 1, UPPER(@Char));
            SET @IsFirstLetter = 0;
        END
        ELSE IF @Char IN (' ', ';', ':', '!', '?', ',', '.', '_', '-', '/', '&', '''', '(')
        BEGIN
            SET @IsFirstLetter = 1;
        END
        ELSE
        BEGIN
            SET @IsFirstLetter = 0;
        END
        SET @i = @i + 1;
    END

    RETURN @OutputText;
END

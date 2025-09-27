-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Creates an acronym from a phrase.
-- Sample:
-- SELECT [dbo].[ZzAcronym]('HyperText Markup Language');
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzAcronym] (@Phrase NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @Acronym NVARCHAR(MAX) = '';
    DECLARE @i INT = 1;
    DECLARE @IsFirstLetter BIT = 1;

    SET @Phrase = LTRIM(RTRIM(@Phrase));

    WHILE @i <= LEN(@Phrase)
    BEGIN
        DECLARE @Char NCHAR(1) = SUBSTRING(@Phrase, @i, 1);
        IF @IsFirstLetter = 1 AND @Char LIKE '[A-Za-z]'
        BEGIN
            SET @Acronym = @Acronym + UPPER(@Char);
            SET @IsFirstLetter = 0;
        END
        ELSE IF @Char IN (' ', '-')
        BEGIN
            SET @IsFirstLetter = 1;
        END
        SET @i = @i + 1;
    END

    RETURN @Acronym;
END

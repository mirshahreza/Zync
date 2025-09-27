-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Converts a string into a clean, URL-friendly "slug".
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzSlugify] (@Input NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @Output NVARCHAR(MAX);

    -- Convert to lowercase
    SET @Output = LOWER(@Input);

    -- Remove non-alphanumeric characters, replacing them with a space
    DECLARE @i INT = 1;
    DECLARE @CleanString NVARCHAR(MAX) = '';
    WHILE @i <= LEN(@Output)
    BEGIN
        DECLARE @Char NCHAR(1) = SUBSTRING(@Output, @i, 1);
        IF @Char LIKE '[a-z0-9]' OR @Char = ' '
            SET @CleanString = @CleanString + @Char;
        ELSE
            SET @CleanString = @CleanString + ' ';
        SET @i = @i + 1;
    END
    SET @Output = @CleanString;

    -- Replace multiple spaces/hyphens with a single hyphen
    WHILE CHARINDEX('  ', @Output) > 0
        SET @Output = REPLACE(@Output, '  ', ' ');
    
    SET @Output = LTRIM(RTRIM(@Output));
    SET @Output = REPLACE(@Output, ' ', '-');

    WHILE CHARINDEX('--', @Output) > 0
        SET @Output = REPLACE(@Output, '--', '-');

    RETURN @Output;
END

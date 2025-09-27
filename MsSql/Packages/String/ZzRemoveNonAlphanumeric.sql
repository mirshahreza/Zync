-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Removes all characters from a string that are not letters or numbers.
-- Sample:
-- SELECT [dbo].[ZzRemoveNonAlphanumeric]('Hello, World! 123');
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzRemoveNonAlphanumeric] (@InputString NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @CleanedString NVARCHAR(MAX) = '';
    DECLARE @i INT = 1;

    WHILE @i <= LEN(@InputString)
    BEGIN
        DECLARE @Char NCHAR(1) = SUBSTRING(@InputString, @i, 1);
        IF @Char LIKE '[A-Za-z0-9]'
            SET @CleanedString = @CleanedString + @Char;
        SET @i = @i + 1;
    END

    RETURN @CleanedString;
END

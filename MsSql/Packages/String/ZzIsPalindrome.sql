-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Checks if a string is a palindrome.
-- Sample:
-- SELECT [dbo].[ZzIsPalindrome]('A man a plan a canal Panama');
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzIsPalindrome] (@InputString NVARCHAR(MAX))
RETURNS BIT
AS
BEGIN
    DECLARE @CleanedString NVARCHAR(MAX) = '';
    DECLARE @i INT = 1;

    -- Clean the string to keep only alphanumeric characters
    WHILE @i <= LEN(@InputString)
    BEGIN
        DECLARE @Char NCHAR(1) = SUBSTRING(@InputString, @i, 1);
        IF @Char LIKE '[A-Za-z0-9]'
            SET @CleanedString = @CleanedString + LOWER(@Char);
        SET @i = @i + 1;
    END

    -- Check if the cleaned string is equal to its reverse
    IF @CleanedString = REVERSE(@CleanedString)
        RETURN 1;

    RETURN 0;
END

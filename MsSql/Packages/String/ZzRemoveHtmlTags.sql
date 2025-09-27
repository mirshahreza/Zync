-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Strips all HTML/XML tags from a string.
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzRemoveHtmlTags] (@HtmlString NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @PlainText NVARCHAR(MAX) = @HtmlString;
    DECLARE @Start INT, @End INT;

    SET @Start = CHARINDEX('<', @PlainText);
    SET @End = CHARINDEX('>', @PlainText, @Start);

    WHILE @Start > 0 AND @End > @Start
    BEGIN
        SET @PlainText = STUFF(@PlainText, @Start, @End - @Start + 1, '');
        SET @Start = CHARINDEX('<', @PlainText);
        SET @End = CHARINDEX('>', @PlainText, @Start);
    END

    -- Also handle encoded characters like &nbsp;
    SET @PlainText = REPLACE(@PlainText, '&nbsp;', ' ');
    SET @PlainText = REPLACE(@PlainText, '&lt;', '<');
    SET @PlainText = REPLACE(@PlainText, '&gt;', '>');
    SET @PlainText = REPLACE(@PlainText, '&amp;', '&');
    -- Add more replacements as needed

    RETURN @PlainText;
END

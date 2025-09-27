-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Wraps a long string to a specified line width.
-- Sample:
-- SELECT [dbo].[ZzWrapText]('This is a very long string that needs to be wrapped.', 20);
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzWrapText]
(
    @Text NVARCHAR(MAX),
    @LineWidth INT
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @Result NVARCHAR(MAX) = '';
    DECLARE @CurrentPos INT = 1;
    DECLARE @LineBreakChar NCHAR(2) = CHAR(13) + CHAR(10); -- CRLF

    WHILE @CurrentPos < LEN(@Text)
    BEGIN
        DECLARE @Line NVARCHAR(MAX) = SUBSTRING(@Text, @CurrentPos, @LineWidth);
        DECLARE @LastSpace INT;

        IF (LEN(@Line) = @LineWidth)
        BEGIN
            SET @LastSpace = CHARINDEX(' ', REVERSE(@Line));
            IF @LastSpace > 0
            BEGIN
                SET @Line = LEFT(@Line, @LineWidth - @LastSpace);
            END
        END
        
        SET @Result = @Result + @Line + @LineBreakChar;
        SET @CurrentPos = @CurrentPos + LEN(@Line) + 1;
        
        -- Trim leading space for the next line
        WHILE SUBSTRING(@Text, @CurrentPos, 1) = ' '
            SET @CurrentPos = @CurrentPos + 1;
    END

    RETURN @Result;
END

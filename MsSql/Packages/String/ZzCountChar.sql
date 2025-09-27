-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-05-18
-- Description:	Counts the total number of occurrences of a specific character within a given string by iterating through it.
-- Sample:
-- SELECT [dbo].[ZzCountChar]('hello world', 'l');
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzCountChar] 
( 
    @pInput NVARCHAR(MAX), 
    @pSearchChar CHAR(1) 
)
RETURNS INT
BEGIN

    DECLARE @vInputLength        INT
    DECLARE @vIndex              INT
    DECLARE @vCount              INT

    SET @vCount = 0
    SET @vIndex = 1
    SET @vInputLength = LEN(@pInput)

    WHILE @vIndex <= @vInputLength
    BEGIN
        IF SUBSTRING(@pInput, @vIndex, 1) = @pSearchChar
            SET @vCount = @vCount + 1

        SET @vIndex = @vIndex + 1
    END

    RETURN @vCount

END
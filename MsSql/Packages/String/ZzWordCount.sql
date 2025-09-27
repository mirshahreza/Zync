-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Counts the total number of words in a given string.
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzWordCount] (@InputString NVARCHAR(MAX))
RETURNS INT
AS
BEGIN
    -- First, clean up the string by removing extra spaces
    DECLARE @CleanedString NVARCHAR(MAX) = DBO.ZzRemoveExtraSpaces(@InputString);
    
    IF @CleanedString = ''
        RETURN 0;

    -- The number of words is one more than the number of spaces
    RETURN LEN(@CleanedString) - LEN(REPLACE(@CleanedString, ' ', '')) + 1;
END

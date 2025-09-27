-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Removes all leading/trailing spaces and collapses multiple internal spaces into one.
-- Sample:
-- SELECT [dbo].[ZzRemoveExtraSpaces]('  hello   world  ');
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzRemoveExtraSpaces] (@InputString NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    SET @InputString = LTRIM(RTRIM(@InputString));
    WHILE CHARINDEX('  ', @InputString) > 0
        SET @InputString = REPLACE(@InputString, '  ', ' ');
    RETURN @InputString;
END

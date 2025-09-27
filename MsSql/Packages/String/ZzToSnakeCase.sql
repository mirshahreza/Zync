-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Converts a string to snake_case.
-- Sample:
-- SELECT [dbo].[ZzToSnakeCase]('helloWorld Test');
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzToSnakeCase] (@InputString NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @Result NVARCHAR(MAX) = '';
    DECLARE @i INT = 1;

    SET @InputString = DBO.ZzRemoveExtraSpaces(LOWER(@InputString));

    WHILE @i <= LEN(@InputString)
    BEGIN
        DECLARE @Char NCHAR(1) = SUBSTRING(@InputString, @i, 1);
        IF @Char = ' '
            SET @Result = @Result + '_';
        ELSE
            SET @Result = @Result + @Char;
        SET @i = @i + 1;
    END
    RETURN @Result;
END

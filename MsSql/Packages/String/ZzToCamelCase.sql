-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Converts a string to camelCase.
-- Sample:
-- SELECT [dbo].[ZzToCamelCase]('hello_world-test');
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzToCamelCase] (@InputString NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @Result NVARCHAR(MAX) = '';
    DECLARE @i INT = 1;
    DECLARE @CapitalizeNext BIT = 0;

    SET @InputString = LOWER(LTRIM(RTRIM(@InputString)));

    WHILE @i <= LEN(@InputString)
    BEGIN
        DECLARE @Char NCHAR(1) = SUBSTRING(@InputString, @i, 1);
        IF @Char IN (' ', '_', '-')
        BEGIN
            SET @CapitalizeNext = 1;
        END
        ELSE
        BEGIN
            IF @CapitalizeNext = 1
            BEGIN
                SET @Result = @Result + UPPER(@Char);
                SET @CapitalizeNext = 0;
            END
            ELSE
            BEGIN
                SET @Result = @Result + @Char;
            END
        END
        SET @i = @i + 1;
    END
    RETURN @Result;
END

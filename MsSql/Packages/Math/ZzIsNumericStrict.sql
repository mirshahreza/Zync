-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	A more reliable version of ISNUMERIC() that strictly validates if a string is a valid number.
-- Sample:
-- SELECT [dbo].[ZzIsNumericStrict]('123.45');
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzIsNumericStrict] (@Value NVARCHAR(MAX))
RETURNS BIT
AS
BEGIN
    RETURN CASE
        WHEN ISNUMERIC(@Value) = 1
             AND @Value NOT LIKE '%[^-0-9.]%' -- Contains only valid numeric characters
             AND @Value NOT LIKE '%-%' -- No minus sign in the middle
             AND @Value NOT LIKE '%.%.%' -- At most one decimal point
             AND @Value NOT IN ('.', '-', '+', '-.')
        THEN 1
        ELSE 0
    END;
END

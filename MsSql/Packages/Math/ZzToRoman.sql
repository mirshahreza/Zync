-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Converts an integer into its Roman numeral equivalent (e.g., 2024 becomes "MMXXIV").
-- Sample:
-- SELECT [dbo].[ZzToRoman](2024);
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzToRoman] (@number INT)
RETURNS VARCHAR(255)
AS
BEGIN
    IF @number <= 0 OR @number >= 4000
        RETURN 'Invalid Number';

    DECLARE @roman VARCHAR(255) = '';
    DECLARE @numerals TABLE (Value INT, Symbol VARCHAR(2));
    INSERT INTO @numerals VALUES
        (1000, 'M'), (900, 'CM'), (500, 'D'), (400, 'CD'), (100, 'C'),
        (90, 'XC'), (50, 'L'), (40, 'XL'), (10, 'X'), (9, 'IX'),
        (5, 'V'), (4, 'IV'), (1, 'I');

    DECLARE @value INT, @symbol VARCHAR(2);

    DECLARE cur CURSOR FOR SELECT Value, Symbol FROM @numerals ORDER BY Value DESC;
    OPEN cur;
    FETCH NEXT FROM cur INTO @value, @symbol;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        WHILE @number >= @value
        BEGIN
            SET @roman = @roman + @symbol;
            SET @number = @number - @value;
        END
        FETCH NEXT FROM cur INTO @value, @symbol;
    END

    CLOSE cur;
    DEALLOCATE cur;

    RETURN @roman;
END

-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Converts a number into its full word representation (e.g., 123 becomes "One Hundred Twenty-Three").
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzToWords] (@Number AS BIGINT)
RETURNS VARCHAR(MAX)
AS
BEGIN
    DECLARE @Below20 TABLE (ID INT, Word VARCHAR(20));
    INSERT @Below20 VALUES (0, ''), (1, 'One'), (2, 'Two'), (3, 'Three'), (4, 'Four'), (5, 'Five'), (6, 'Six'), (7, 'Seven'), (8, 'Eight'), (9, 'Nine'), (10, 'Ten'), (11, 'Eleven'), (12, 'Twelve'), (13, 'Thirteen'), (14, 'Fourteen'), (15, 'Fifteen'), (16, 'Sixteen'), (17, 'Seventeen'), (18, 'Eighteen'), (19, 'Nineteen');

    DECLARE @Tens TABLE (ID INT, Word VARCHAR(20));
    INSERT @Tens VALUES (2, 'Twenty'), (3, 'Thirty'), (4, 'Forty'), (5, 'Fifty'), (6, 'Sixty'), (7, 'Seventy'), (8, 'Eighty'), (9, 'Ninety');

    DECLARE @English VARCHAR(MAX);

    IF @Number = 0
        RETURN 'Zero';

    WITH cte AS (
        SELECT
            CASE
                WHEN @Number >= 1000000000000000000 THEN dbo.ZzToWords(@Number / 1000000000000000000) + ' Quintillion ' + dbo.ZzToWords(@Number % 1000000000000000000)
                WHEN @Number >= 1000000000000000 THEN dbo.ZzToWords(@Number / 1000000000000000) + ' Quadrillion ' + dbo.ZzToWords(@Number % 1000000000000000)
                WHEN @Number >= 1000000000000 THEN dbo.ZzToWords(@Number / 1000000000000) + ' Trillion ' + dbo.ZzToWords(@Number % 1000000000000)
                WHEN @Number >= 1000000000 THEN dbo.ZzToWords(@Number / 1000000000) + ' Billion ' + dbo.ZzToWords(@Number % 1000000000)
                WHEN @Number >= 1000000 THEN dbo.ZzToWords(@Number / 1000000) + ' Million ' + dbo.ZzToWords(@Number % 1000000)
                WHEN @Number >= 1000 THEN dbo.ZzToWords(@Number / 1000) + ' Thousand ' + dbo.ZzToWords(@Number % 1000)
                WHEN @Number >= 100 THEN dbo.ZzToWords(@Number / 100) + ' Hundred ' + dbo.ZzToWords(@Number % 100)
                WHEN @Number >= 20 THEN (SELECT Word FROM @Tens WHERE ID = @Number / 10) + ' ' + (SELECT Word FROM @Below20 WHERE ID = @Number % 10)
                ELSE (SELECT Word FROM @Below20 WHERE ID = @Number)
            END AS Word
    )
    SELECT @English = Word FROM cte;

    RETURN LTRIM(RTRIM(REPLACE(REPLACE(@English, '  ', ' '), ' ,', ',')));
END

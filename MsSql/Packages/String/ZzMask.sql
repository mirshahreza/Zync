-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Partially hides sensitive information in a string.
-- Sample:
-- SELECT [dbo].[ZzMask]('1234-5678-9012-3456', 4, 4, '*');
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzMask]
(
    @InputString NVARCHAR(MAX),
    @VisibleCharsLeft INT,
    @VisibleCharsRight INT,
    @MaskChar NCHAR(1) = 'X'
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @Length INT = LEN(@InputString);
    IF @Length <= @VisibleCharsLeft + @VisibleCharsRight
        RETURN @InputString;

    DECLARE @MaskLength INT = @Length - @VisibleCharsLeft - @VisibleCharsRight;

    RETURN LEFT(@InputString, @VisibleCharsLeft) + 
           REPLICATE(@MaskChar, @MaskLength) + 
           RIGHT(@InputString, @VisibleCharsRight);
END

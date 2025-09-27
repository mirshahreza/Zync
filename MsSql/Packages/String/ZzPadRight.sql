-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Pads a string to a specified length with a given character on the right.
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzPadRight]
(
    @InputString NVARCHAR(MAX),
    @Length INT,
    @PadChar NCHAR(1) = ' '
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    RETURN @InputString + REPLICATE(@PadChar, @Length - LEN(@InputString));
END

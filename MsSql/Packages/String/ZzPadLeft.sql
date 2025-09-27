-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Pads a string to a specified length with a given character on the left.
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzPadLeft]
(
    @InputString NVARCHAR(MAX),
    @Length INT,
    @PadChar NCHAR(1) = ' '
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    RETURN REPLICATE(@PadChar, @Length - LEN(@InputString)) + @InputString;
END

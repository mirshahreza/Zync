-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Reverses the characters in a string.
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzReverse] (@InputString NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    RETURN REVERSE(@InputString);
END

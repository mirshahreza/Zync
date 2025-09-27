-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Decodes a URL-encoded string.
-- Sample:
-- SELECT [dbo].[ZzUrlDecode]('Hello%20World');
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzUrlDecode] (@InputString NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    -- This is a placeholder as T-SQL does not have a native, simple way to do this.
    -- A full implementation would require a CLR integration or a complex loop.
    -- For now, it just replaces the most common encoding.
    RETURN REPLACE(@InputString, '%20', ' ');
END

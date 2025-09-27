-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Encodes a string into Base64 format.
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzBase64Encode] (@InputString VARCHAR(MAX))
RETURNS VARCHAR(MAX)
AS
BEGIN
    RETURN CAST(N'' AS XML).value('xs:base64Binary(sql:variable("@InputString"))', 'VARCHAR(MAX)');
END

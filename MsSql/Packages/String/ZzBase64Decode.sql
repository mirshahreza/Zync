-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Decodes a Base64 formatted string.
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzBase64Decode] (@Base64String VARCHAR(MAX))
RETURNS VARCHAR(MAX)
AS
BEGIN
    RETURN CAST(CAST(N'' AS XML).value('xs:base64Binary(sql:variable("@Base64String"))', 'VARBINARY(MAX)') AS VARCHAR(MAX));
END

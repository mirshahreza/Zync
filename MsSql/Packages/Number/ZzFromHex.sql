-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2025-09-27
-- Description:	Converts a hexadecimal string to its integer representation.
-- =============================================
CREATE OR ALTER FUNCTION [DBO].[ZzFromHex] (@Hex VARCHAR(MAX))
RETURNS INT
AS
BEGIN
    RETURN CONVERT(INT, CAST('' AS XML).value('xs:hexBinary(sql:variable("@Hex"))', 'varbinary(max)'));
END

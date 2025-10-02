-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date:	2025-10-02
-- Description:	Convert JSON array to table format
-- Sample:		SELECT * FROM [dbo].[ZzJsonToTable]('[{"id":1,"name":"John"}]');
-- =============================================
CREATE OR ALTER FUNCTION dbo.ZzJsonToTable(
    @json NVARCHAR(MAX)
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        [key] AS RowIndex,
        [value] AS JsonValue,
        [type] AS ValueType
    FROM OPENJSON(@json)
    WHERE ISJSON(@json) = 1
)
GO
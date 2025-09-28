-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-06-21
-- Description:	Checks for the existence of any database object (table, view, procedure, etc.) by its name. Returns a bit via OUTPUT and also SELECTs it for convenience.
-- Sample:
-- DECLARE @Exists BIT; EXEC [dbo].[ZzObjectExist] @ObjectName = 'MyTable', @Exists = @Exists OUTPUT; SELECT @Exists AS Exists;
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[ZzObjectExist]
    @ObjectName VARCHAR(128),
    @Exists BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @Exists = CASE WHEN OBJECT_ID(@ObjectName) IS NULL THEN 0 ELSE 1 END;
    SELECT @Exists AS [Exists];
END


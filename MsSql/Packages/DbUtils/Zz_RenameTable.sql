-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-06-21
-- Description:	Rename a table 
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[Zz_RenameTable]
	@TableName VARCHAR(128),@NewName VARCHAR(128)
AS

BEGIN

	DECLARE @S NVARCHAR(4000);
	SET @S = 'EXEC SP_RENAME '''+@TableName+''','''+@NewName+''';';
	EXECUTE SP_EXECUTESQL @S;

END
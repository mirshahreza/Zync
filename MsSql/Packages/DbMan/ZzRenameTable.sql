-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-06-21
-- Description:	A wrapper for the system stored procedure `sp_rename`, allowing for the safe renaming of a table.
-- Sample:
-- EXEC [dbo].[ZzRenameTable] @TableName = 'OldTableName', @NewName = 'NewTableName';
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[ZzRenameTable]
	@TableName VARCHAR(128),@NewName VARCHAR(128)
AS

BEGIN

	DECLARE @S NVARCHAR(4000);
	SET @S = 'EXEC SP_RENAME '''+@TableName+''','''+@NewName+''';';
	EXECUTE SP_EXECUTESQL @S;

END
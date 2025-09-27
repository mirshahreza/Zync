-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-06-21
-- Description:	A wrapper for the system stored procedure `sp_rename`, allowing for the safe renaming of a specific column within a table.
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[ZzRenameColumn]
	@TableName VARCHAR(128),@InitialName VARCHAR(128),@NewName VARCHAR(128)
AS

BEGIN

	DECLARE @S NVARCHAR(4000);
	SET @S = 'EXEC SP_RENAME '''+@TableName+'.'+@InitialName+''','''+@NewName+''',''COLUMN'';';
	EXECUTE SP_EXECUTESQL @S;

END
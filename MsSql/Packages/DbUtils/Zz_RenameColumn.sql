-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-06-21
-- Description:	Rename a column 
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[Zz_RenameColumn]
	@TableName VARCHAR(128),@InitialName VARCHAR(128),@NewName VARCHAR(128)
AS

BEGIN

	DECLARE @S NVARCHAR(4000);
	SET @S = 'EXEC SP_RENAME '''+@TableName+'.'+@InitialName+''','''+@NewName+''',''COLUMN'';';
	EXECUTE SP_EXECUTESQL @S;

END
-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-06-02
-- Description:	Safely drops a table if it exists in the database, preventing errors that would occur if the table is not found.
-- Sample:
-- EXEC [dbo].[ZzDropTable] @TableName = 'MyTable';
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[ZzDropTable]
	@TableName VARCHAR(128)
AS

BEGIN

	DECLARE @S NVARCHAR(4000);
	SET @S = 'DROP TABLE IF EXISTS ' + @TableName;
	EXECUTE SP_EXECUTESQL @S;

END
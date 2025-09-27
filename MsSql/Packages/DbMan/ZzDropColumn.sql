-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-06-02
-- Description:	Safely drops a column from a table if it exists, preventing errors that would occur if the column is not found.
-- Sample:
-- EXEC [dbo].[ZzDropColumn] @TableName = 'MyTable', @ColumnName = 'MyColumn';
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[ZzDropColumn]
	@TableName VARCHAR(128), @ColumnName VARCHAR(64)
AS

BEGIN

	DECLARE @S NVARCHAR(4000);
	SET @S = 'ALTER TABLE ' + @TableName + ' DROP COLUMN IF EXISTS ' + @ColumnName;
	EXECUTE SP_EXECUTESQL @S;

END
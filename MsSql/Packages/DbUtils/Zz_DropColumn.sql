-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-06-02
-- Description:	Drop a field from a table
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[Zz_DropColumn]
	@TableName VARCHAR(128), @ColumnName VARCHAR(64)
AS

BEGIN

	DECLARE @S NVARCHAR(4000);
	SET @S = 'ALTER TABLE ' + @TableName + ' DROP COLUMN IF EXISTS ' + @ColumnName;
	EXECUTE SP_EXECUTESQL @S;

END
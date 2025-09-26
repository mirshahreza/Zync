-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-06-02
-- Description:	alter a field
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[Zz_AlterColumn]
	@TableName VARCHAR(128), @ColumnName VARCHAR(64), @ColumnTypeSize VARCHAR(64), @AllowNull BIT = 1,@Default NVARCHAR(256) = ''
AS

BEGIN

	DECLARE @S NVARCHAR(4000);
	DECLARE @Allow NVARCHAR(16);
	DECLARE @DefaultName NVARCHAR(256);

	IF(@AllowNull=1)
	BEGIN
		SET @Allow = ' NULL'
	END
	ELSE
	BEGIN
		SET @Allow = ' NOT NULL'
	END

	SET @DefaultName = ISNULL((SELECT TOP 1 Name FROM SYS.DEFAULT_CONSTRAINTS
	WHERE PARENT_OBJECT_ID = OBJECT_ID(@TableName)
	AND PARENT_COLUMN_ID = (SELECT COLUMN_ID FROM SYS.COLUMNS
							WHERE NAME = @ColumnName
							AND OBJECT_ID = OBJECT_ID(@TableName))
						),'NODEFAULT');

	SET @S ='
ALTER TABLE ' + @TableName + ' DROP CONSTRAINT IF EXISTS ' + @DefaultName+';
ALTER TABLE ' + @TableName + ' ALTER COLUMN ' + @ColumnName + ' ' + @ColumnTypeSize + @Allow + ';
IF('''+@Default+'''!='''')
BEGIN
	ALTER TABLE ' + @TableName + ' ADD CONSTRAINT ' + @TableName + '_' + @ColumnName + '_Default DEFAULT '''+@Default+''' FOR ' + @ColumnName + '
END
;';

	EXECUTE SP_EXECUTESQL @S;

END
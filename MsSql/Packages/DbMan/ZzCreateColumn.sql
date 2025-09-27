-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-06-02
-- Description:	Adds a new column to an existing table with a specified name, data type, and nullability.
-- Sample:
-- EXEC [dbo].[ZzCreateColumn] @TableName = 'MyTable', @ColumnName = 'NewColumn', @ColumnTypeSize = 'NVARCHAR(100)', @AllowNull = 1;
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[ZzCreateColumn]
	@TableName VARCHAR(128), @ColumnName VARCHAR(64) , @ColumnTypeSize VARCHAR(64) , @AllowNull BIT = 1
AS

BEGIN

	DECLARE @S NVARCHAR(4000);
	SET @S = 'ALTER TABLE ' + @TableName + ' ADD ' + @ColumnName + ' ' + @ColumnTypeSize;
	IF(@AllowNull=1)
	BEGIN
		SET @S = @S + ' NULL'
	END
	ELSE
	BEGIN
		SET @S = @S + ' NOT NULL'
	END

	EXECUTE SP_EXECUTESQL @S;
END
-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-06-02
-- Description:	Add a field to a table
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[Zz_CreateColumn]
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
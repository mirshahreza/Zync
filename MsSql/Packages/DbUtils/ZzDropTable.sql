-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-06-02
-- Description:	Drop a table from a database
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[ZzDropTable]
	@TableName VARCHAR(128)
AS

BEGIN

	DECLARE @S NVARCHAR(4000);
	SET @S = 'DROP TABLE IF EXISTS ' + @TableName;
	EXECUTE SP_EXECUTESQL @S;

END
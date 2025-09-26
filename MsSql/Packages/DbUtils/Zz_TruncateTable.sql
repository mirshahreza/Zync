-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-06-21
-- Description:	Truncate a table from 
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[Zz_TruncateTable]
	@TableName VARCHAR(128)
AS

BEGIN

	DECLARE @S NVARCHAR(4000);
	SET @S = 'TRUNCATE TABLE ' + @TableName;
	EXECUTE SP_EXECUTESQL @S;

END
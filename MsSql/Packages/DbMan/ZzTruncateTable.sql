-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-06-21
-- Description:	Safely truncates a table by its name, first dropping all foreign key constraints to avoid errors, and then recreating them after the truncation is complete.
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[ZzTruncateTable]
	@TableName VARCHAR(128)
AS

BEGIN

	DECLARE @S NVARCHAR(4000);
	SET @S = 'TRUNCATE TABLE ' + @TableName;
	EXECUTE SP_EXECUTESQL @S;

END
-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-06-21
-- Description:	Drop a Function from a database
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[Zz_DropFunction]
	@FunctionName VARCHAR(128)
AS

BEGIN

	DECLARE @S NVARCHAR(4000);
	SET @S = 'DROP FUNCTION IF EXISTS ' + @FunctionName;
	EXECUTE SP_EXECUTESQL @S;

END

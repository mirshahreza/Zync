-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-06-21
-- Description:	Creates a new table function
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[Zz_CreateEmptyTableFunction]
	@TableFunctionName VARCHAR(128)
AS

BEGIN

	DECLARE @S NVARCHAR(4000);
	SET @S = '
CREATE FUNCTION [DBO].['+@TableFunctionName+'] 
(
	@Param1 INT,@Param2 INT
)
RETURNS TABLE
AS
RETURN
(
	SELECT @Param1 A, @Param2 B 
)
	';

	EXECUTE SP_EXECUTESQL @S;
END
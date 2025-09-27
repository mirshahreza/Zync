-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-06-21
-- Description:	Creates a new, empty placeholder table-valued function with two dummy parameters.
-- Sample:
-- EXEC [dbo].[ZzCreateEmptyTableFunction] @TableValuedFunctionName = 'MyNewTableFunction';
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[ZzCreateEmptyTableFunction]
	@TableValuedFunctionName VARCHAR(128)
AS
BEGIN

	DECLARE @S NVARCHAR(4000);
	SET @S = '
CREATE FUNCTION [DBO].['+@TableValuedFunctionName+'] 
(
	@Param1 INT, @Param2 INT
)
RETURNS TABLE
AS
RETURN
(
	SELECT 1 AS A, 2 AS B WHERE 1 = 0
)
	';

	EXECUTE SP_EXECUTESQL @S;
END

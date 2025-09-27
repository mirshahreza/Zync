CREATE OR ALTER PROCEDURE [DBO].[ZzCreateEmptyTableFunction]
	@TableFunctionName VARCHAR(128)
CREATE OR ALTER FUNCTION [DBO].['+@TableFunctionName+'] 

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
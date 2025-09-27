-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-06-21
-- Description:	Creates a new, empty placeholder scalar function with two dummy parameters that returns a fixed integer value.
-- Sample:
-- EXEC [dbo].[ZzCreateEmptyScalarFunction] @ScalarValuedFunctionName = 'MyNewFunction';
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[ZzCreateEmptyScalarFunction]
	@ScalarValuedFunctionName VARCHAR(128)
AS

BEGIN

	DECLARE @S NVARCHAR(4000);
	SET @S = '
	CREATE OR ALTER  FUNCTION [DBO].['+@ScalarValuedFunctionName+'] 
	( 
		@Param1 INT, @Param2 INT 
	)
	RETURNS INT
	BEGIN
		RETURN 1
	END
	';

	EXECUTE SP_EXECUTESQL @S;
END
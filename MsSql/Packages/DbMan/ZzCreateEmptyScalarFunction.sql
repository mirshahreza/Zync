-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-06-21
-- Description:	Creates a new, empty placeholder scalar function with two dummy parameters that returns a fixed integer value.
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[ZzCreateEmptyScalarFunction]
	@ScalarFunctionName VARCHAR(128)
AS

BEGIN

	DECLARE @S NVARCHAR(4000);
	SET @S = '
CREATE   FUNCTION [DBO].['+@ScalarFunctionName+'] 
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
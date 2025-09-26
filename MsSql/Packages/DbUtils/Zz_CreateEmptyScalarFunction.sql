-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-06-21
-- Description:	Creates a new scalar function
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[Zz_CreateEmptyScalarFunction]
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
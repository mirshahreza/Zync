-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-06-21
-- Description:	Safely drops a function if it exists in the database, preventing errors that would occur if the function is not found.
-- Sample:
-- EXEC [dbo].[ZzDropFunction] @FunctionName = 'MyFunction';
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[ZzDropFunction]
	@FunctionName VARCHAR(128)
AS

BEGIN

	DECLARE @S NVARCHAR(4000);
	SET @S = 'DROP FUNCTION IF EXISTS ' + @FunctionName;
	EXECUTE SP_EXECUTESQL @S;

END

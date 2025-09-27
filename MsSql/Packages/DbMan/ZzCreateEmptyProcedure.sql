-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-06-21
-- Description:	Creates a new, empty placeholder stored procedure with a single dummy parameter.
-- Sample:
-- EXEC [dbo].[ZzCreateEmptyProcedure] @ProcedureName = 'MyNewProcedure';
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[ZzCreateEmptyProcedure]
	@ProcedureName VARCHAR(128)
AS

BEGIN

	DECLARE @S NVARCHAR(4000);
	SET @S = '
CREATE PROCEDURE [DBO].['+@ProcedureName+'] 
	@Param1 INT
AS
BEGIN
	SELECT @Param1 A;
END
';

	EXECUTE SP_EXECUTESQL @S;
END
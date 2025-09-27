-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-06-02
-- Description:	Safely drops a stored procedure if it exists in the database, preventing errors that would occur if the procedure is not found.
-- Sample:
-- EXEC [dbo].[ZzDropProcedure] @ProcedureName = 'MyProcedure';
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[ZzDropProcedure]
	@ProcedureName VARCHAR(128)
AS

BEGIN

	DECLARE @S NVARCHAR(4000);
	SET @S = 'DROP PROCEDURE IF EXISTS ' + @ProcedureName;
	EXECUTE SP_EXECUTESQL @S;

END

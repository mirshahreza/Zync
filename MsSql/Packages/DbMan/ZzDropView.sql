-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-06-02
-- Description:	Safely drops a view if it exists in the database, preventing errors that would occur if the view is not found.
-- Sample:
-- EXEC [dbo].[ZzDropView] @ViewName = 'MyView';
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[ZzDropView]
	@ViewName VARCHAR(128)
AS

BEGIN

	DECLARE @S NVARCHAR(4000);
	SET @S = 'DROP VIEW IF EXISTS ' + @ViewName;
	EXECUTE SP_EXECUTESQL @S;

END
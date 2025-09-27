-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-06-21
-- Description:	Creates a new, empty placeholder view with a single dummy column, which can be altered later.
-- Sample:
-- EXEC [dbo].[ZzCreateEmptyView] @ViewName = 'MyNewView';
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[ZzCreateEmptyView]
	@ViewName VARCHAR(128)
AS

BEGIN

	DECLARE @S NVARCHAR(4000);
	SET @S = '
CREATE VIEW [DBO].['+@ViewName+'] AS
	';

	EXECUTE SP_EXECUTESQL @S;
END
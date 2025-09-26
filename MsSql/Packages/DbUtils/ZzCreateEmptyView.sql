-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-06-21
-- Description:	Creates a new view
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[ZzCreateEmptyView]
	@ViewName VARCHAR(128)
AS

BEGIN

	DECLARE @S NVARCHAR(4000);
	SET @S = '
CREATE VIEW [DBO].['+@ViewName+'] AS
	SELECT 1 A;
	';

	EXECUTE SP_EXECUTESQL @S;
END
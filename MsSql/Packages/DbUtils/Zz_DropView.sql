-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-06-02
-- Description:	Drop a view from a database
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[Zz_DropView]
	@ViewName VARCHAR(128)
AS

BEGIN

	DECLARE @S NVARCHAR(4000);
	SET @S = 'DROP VIEW IF EXISTS ' + @ViewName;
	EXECUTE SP_EXECUTESQL @S;

END
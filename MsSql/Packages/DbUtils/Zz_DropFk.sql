-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-07-04
-- Description:	Drops a Fk
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[Zz_DropFk]
	@FkName VARCHAR(128),
	@BaseTableName VARCHAR(128)
AS

BEGIN

	DECLARE @S NVARCHAR(4000);

	IF(@FkName IS NOT NULL AND @FkName!='')
	BEGIN
		SET @S = '
ALTER TABLE '+@BaseTableName+'
DROP CONSTRAINT IF EXISTS '+@FkName+'
;
		';
	END

	EXECUTE SP_EXECUTESQL @S;
END
-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-07-04
-- Description:	Safely drops a foreign key constraint from a specified table if the constraint name is provided.
-- Sample:
-- EXEC [dbo].[ZzDropFk] @FkName = 'FK_Orders_Customers', @BaseTableName = 'Orders';
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[ZzDropFk]
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
-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-06-02
-- Description:	Creates or Alters a Fk
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[Zz_CreateOrAlterFk]
	@FkName VARCHAR(128),
	@BaseTableName VARCHAR(128), @BaseColumnName VARCHAR(64) , 
	@TargetTableName VARCHAR(128), @TargetColumnName VARCHAR(64) , 
	@EnforceRelation BIT=1 
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

	SET @S = @S + '
ALTER TABLE '+@BaseTableName+'
ADD CONSTRAINT '+@FkName+' FOREIGN KEY ('+@BaseColumnName+')
    REFERENCES '+@TargetTableName+' ('+@TargetColumnName+')
	';

	IF(@EnforceRelation=1)
	BEGIN
		SET @S = @S + '
    ON DELETE CASCADE
    ON UPDATE CASCADE
	;
		';
	END

	EXECUTE SP_EXECUTESQL @S;
END
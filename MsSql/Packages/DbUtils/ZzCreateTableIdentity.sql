/*
EXEC DBO.Zync 'DbUtils/ZzObjectExist.sql'
*/
-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-06-02
-- Description:	Creates a new table with a primary key column that uses an auto-incrementing IDENTITY property.
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[ZzCreateTableIdentity]
	@TableName VARCHAR(128), @PkFieldName VARCHAR(64) = 'Id', @PkFieldType VARCHAR(32) = 'INT',
	@PkIdentityStart INT=1,@PkIdentityStep INT=1,
	@IgnoreIfExist BIT=1
AS

BEGIN

	DECLARE @ObjectExist BIT = DBO.ZzObjectExist(@TableName);
	IF(@ObjectExist=1 AND @IgnoreIfExist=1) RETURN;

	EXEC DBO.ZzDropTable @TableName;

	DECLARE @S NVARCHAR(4000) = '
CREATE TABLE [DBO].['+@TableName+'](
	['+@PkFieldName+'] ['+@PkFieldType+'] IDENTITY('+CAST(@PkIdentityStart AS VARCHAR)+','+CAST(@PkIdentityStep AS VARCHAR)+') NOT NULL,
 CONSTRAINT [PK_'+@TableName+'_'+@PkFieldName+'] PRIMARY KEY CLUSTERED 
(
	['+@PkFieldName+'] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]	
	';

	EXECUTE SP_EXECUTESQL @S;
END
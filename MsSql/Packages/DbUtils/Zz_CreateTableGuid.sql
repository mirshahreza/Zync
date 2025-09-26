/*
EXEC Zzz_Deploy 'DbUtils/Zz_ObjectExist.sql'
*/
-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-06-02
-- Description:	Create a table with a Guid column
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[Zz_CreateTableGuid]
	@TableName VARCHAR(128), @PkFieldName VARCHAR(64) = 'Id',
	@IgnoreIfExist BIT=1
AS

BEGIN

	DECLARE @ObjectExist BIT = dbo.Zz_ObjectExist(@TableName);
	IF(@ObjectExist=1 AND @IgnoreIfExist=1) RETURN;

	EXEC dbo.Zz_DropTable @TableName;

	DECLARE @S NVARCHAR(4000) = '
CREATE TABLE [DBO].['+@TableName+'](
	['+@PkFieldName+'] [UNIQUEIDENTIFIER] NOT NULL,
 CONSTRAINT [PK_'+@TableName+'_'+@PkFieldName+'] PRIMARY KEY CLUSTERED 
(
	['+@PkFieldName+'] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY];

ALTER TABLE [DBO].['+@TableName+'] ADD  CONSTRAINT [DF_'+@TableName+'_'+@PkFieldName+']  DEFAULT (NEWID()) FOR ['+@PkFieldName+'];

	';

	EXECUTE SP_EXECUTESQL @S;
END
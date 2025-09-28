/*
EXEC DBO.Zync 'i DbMan/ZzDropTable.sql'
EXEC DBO.Zync 'i DbMan/ZzObjectExist.sql'
*/
-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2023-06-02
-- Description:	Creates a new table with a UNIQUEIDENTIFIER (GUID) primary key column, automatically populated with new GUIDs on insertion.
-- Sample:
-- EXEC [dbo].[ZzCreateTableGuid] @TableName = 'MyGuidTable', @PkFieldName = 'GuidId', @IgnoreIfExist = 1;
-- =============================================
CREATE OR ALTER PROCEDURE [DBO].[ZzCreateTableGuid]
	@TableName VARCHAR(128), @PkFieldName VARCHAR(64) = 'Id',
	@IgnoreIfExist BIT=1
AS

BEGIN

	DECLARE @ObjectExist BIT;
	EXEC dbo.ZzObjectExist @ObjectName = @TableName, @Exists = @ObjectExist OUTPUT;
	IF(@ObjectExist=1 AND @IgnoreIfExist=1) RETURN;

	EXEC dbo.ZzDropTable @TableName;

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
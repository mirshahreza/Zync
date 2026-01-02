-- =============================================
-- Author:      SMO scripted
-- Create date: 2026-01-02
-- Description: Create table [dbo].[BaseZetadata] with keys, defaults, and indexes.
-- =============================================
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BaseZetadata]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[BaseZetadata](
	[StructureId] [varchar](32) NOT NULL,
	[ConnectionName] [varchar](16) NOT NULL,
	[ObjectName] [nvarchar](64) NOT NULL,
	[ObjectType] [varchar](16) NOT NULL,
	[DataType] [varchar](32) NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedOn] [datetime] NULL,
	[HumanTitleEn] [varchar](128) NOT NULL,
	[HumanTitleEnVector] [vector](3, float32) NOT NULL,
	[HumanTitleNative] [nvarchar](256) NOT NULL,
	[HumanTitleNativeVector] [vector](3, float32) NOT NULL,
	[NoteEn] [varchar](1024) NOT NULL,
	[NoteEnVector] [vector](3, float32) NOT NULL,
	[NoteNative] [nvarchar](2048) NOT NULL,
	[NoteNativeVector] [vector](3, float32) NOT NULL,
	[KeywordsEn] [varchar](256) NOT NULL,
	[KeywordsEnVector] [vector](3, float32) NOT NULL,
	[KeywordsNative] [nvarchar](512) NOT NULL,
	[KeywordsNativeVector] [vector](3, float32) NOT NULL,
 CONSTRAINT [PK_BaseSchemaMetadata] PRIMARY KEY CLUSTERED 
(
	[StructureId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

END


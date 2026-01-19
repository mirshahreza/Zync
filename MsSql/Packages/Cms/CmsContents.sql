-- =============================================
-- Author:      SMO scripted
-- Create date: 2025-09-28
-- Description: Create table [dbo].[CmsContents] with keys, defaults, and indexes.
-- =============================================
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CmsContents]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CmsContents](
	[Id] [int] NOT NULL,
	[ParentId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[ContentTypeId] [varchar](64) NULL,
	[TemplateId] [varchar](64) NULL,
	[Title] [nvarchar](256) NOT NULL,
	[Summary] [nvarchar](4000) NULL,
	[Body] [ntext] NULL,
	[File_FileBody] [image] NOT NULL,
	[File_FileBody_xs] [image] NOT NULL,
	[File_FileName] [nvarchar](128) NOT NULL,
	[File_FileSize] [int] NOT NULL,
	[File_FileMime] [varchar](128) NOT NULL,
	[LanguageId] [varchar](64) NULL,
	[RecordStateId] [varchar](64) NULL,
	[RecordStateIdUpdatedBy] [int] NULL,
	[RecordStateIdUpdatedOn] [datetime] NULL,
	[CommentsPolicyId] [varchar](64) NULL,
	[ShowManualRelatedItems] [bit] NOT NULL,
	[ShowSystemRelatedItems] [bit] NOT NULL,
 CONSTRAINT [PK_CmsContents_CreatedBy] PRIMARY KEY CLUSTERED 
(
	[CreatedBy] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[CmsContents] ADD  CONSTRAINT [DF_CmsContents_ShowManualRelatedItems]  DEFAULT ((1)) FOR [ShowManualRelatedItems]
GO

ALTER TABLE [dbo].[CmsContents] ADD  CONSTRAINT [DF_CmsContents_ShowSystemRelatedItems]  DEFAULT ((0)) FOR [ShowSystemRelatedItems]
GO






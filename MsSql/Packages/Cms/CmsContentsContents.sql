-- =============================================
-- Author:      SMO scripted
-- Create date: 2025-09-28
-- Description: Create table [dbo].[CmsContentsContents] with keys, defaults, and indexes.
-- =============================================
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CmsContentsContents]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CmsContentsContents](
	[Id] [int] IDENTITY(100000000,1) NOT NULL,
	[ContentId] [int] NULL,
	[RelatedContentId] [int] NULL,
	[ViewOrder] [int] NULL,
	[TemplateId] [varchar](64) NULL,
 CONSTRAINT [PK_CmsContentsContents] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO



-- =============================================
-- Author:      SMO scripted
-- Create date: 2025-09-28
-- Description: Create table [dbo].[CmsContentsTags] with keys, defaults, and indexes.
-- =============================================
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CmsContentsTags]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CmsContentsTags](
	[Id] [int] IDENTITY(100000000,1) NOT NULL,
	[ContentId] [varchar](64) NOT NULL,
	[TagId] [varchar](64) NOT NULL
) ON [PRIMARY]
GO




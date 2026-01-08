-- =============================================
-- Author:      SMO scripted
-- Create date: 2025-09-28
-- Description: Create table [dbo].[BaseInfo] with keys, defaults, and indexes.
-- =============================================
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BaseInfo]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[BaseInfo](
	[Id] [varchar](64) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[ParentId] [varchar](64) NULL,
	[Title] [nvarchar](128) NOT NULL,
	[TitleEn] [nvarchar](128) NULL,
	[TitleFa] [nvarchar](128) NULL,
	[TitleAr] [nvarchar](128) NULL,
	[ShortName] [nvarchar](16) NULL,
	[ViewOrder] [float] NULL,
	[Note] [nvarchar](256) NULL,
	[NoteEn] [nvarchar](256) NULL,
	[NoteFa] [nvarchar](256) NULL,
	[NoteAr] [nvarchar](256) NULL,
	[Metadata] [nvarchar](4000) NULL,
	[Value] [int] NULL,
	[IsActive] [bit] NULL,
	[UiColor] [varchar](16) NULL,
	[UiIcon] [varchar](64) NULL,
 CONSTRAINT [PK_AppEnd_BaseInfo] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END

-- Add self-referencing foreign key for BaseInfo.ParentId
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Common_BaseInfo_ParentId_Common_BaseInfo_Id]') AND parent_object_id = OBJECT_ID(N'[dbo].[BaseInfo]'))
ALTER TABLE [dbo].[BaseInfo]  WITH CHECK ADD  CONSTRAINT [Common_BaseInfo_ParentId_Common_BaseInfo_Id] FOREIGN KEY([ParentId])
REFERENCES [dbo].[BaseInfo] ([Id])
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Common_BaseInfo_ParentId_Common_BaseInfo_Id]') AND parent_object_id = OBJECT_ID(N'[dbo].[BaseInfo]'))
ALTER TABLE [dbo].[BaseInfo] CHECK CONSTRAINT [Common_BaseInfo_ParentId_Common_BaseInfo_Id]


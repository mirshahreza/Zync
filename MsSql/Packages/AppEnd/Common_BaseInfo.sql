-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2024-03-31
-- Description:	Table to hold base information - AppEnd LowCode system
-- =============================================
CREATE TABLE [DBO].[Common_BaseInfo](
	[Id] [int] IDENTITY(10000,1) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[ParentId] [int] NULL,
	[Title] [nvarchar](128) NOT NULL,
	[ShortName] [nvarchar](16) NULL,
	[ViewOrder] [float] NULL,
	[Note] [nvarchar](256) NULL,
	[Metadata] [nvarchar](4000) NULL,
	[MetaInfoUpdatedBy] [int] NULL,
	[MetaInfoUpdatedOn] [datetime] NULL,
	[IsActive] [bit] NULL,
	[IsActiveUpdatedBy] [int] NULL,
	[IsActiveUpdatedOn] [datetime] NULL,
	[UiColor] [varchar](16) NULL,
	[UiIcon] [varchar](64) NULL,
	[UiInfoUpdatedBy] [int] NULL,
	[UiInfoUpdatedOn] [datetime] NULL,
 CONSTRAINT [PK_AppEnd_BaseInfo] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY];

ALTER TABLE [dbo].[Common_BaseInfo]  WITH CHECK ADD  CONSTRAINT [Common_BaseInfo_ParentId_Common_BaseInfo_Id] FOREIGN KEY([ParentId])
REFERENCES [dbo].[Common_BaseInfo] ([Id]);

ALTER TABLE [dbo].[Common_BaseInfo] CHECK CONSTRAINT [Common_BaseInfo_ParentId_Common_BaseInfo_Id];


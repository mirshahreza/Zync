-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2024-03-31
-- Description:	Table to hold users activities - AppEnd LowCode system
-- =============================================
CREATE TABLE [DBO].[Common_ActivityLog](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Method] [varchar](128) NOT NULL,
	[IsSucceeded] [bit] NOT NULL,
	[FromCache] [bit] NOT NULL,
	[RecordId] [varchar](64) NULL,
	[EventBy] [int] NOT NULL,
	[EventOn] [datetime] NOT NULL,
	[Duration] [float] NOT NULL,
	[ClientInfo] [varchar](256) NULL,
 CONSTRAINT [PK_AppEnd_ActivityLog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY];


-- =============================================
-- Author:      SMO scripted
-- Create date: 2025-09-28
-- Description: Create table [dbo].[BaseActivityLog] with keys, defaults, and indexes.
-- =============================================
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BaseActivityLog]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[BaseActivityLog](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Controller] [varchar](64) NULL,
	[Method] [varchar](64) NULL,
	[RowId] [varchar](64) NULL,
	[Result] [bit] NULL,
	[Message] [varchar](128) NULL,
	[Duration] [int] NULL,
	[ClientAgent] [nvarchar](256) NULL,
	[ClientIp] [varchar](32) NULL,
	[EventById] [int] NULL,
	[EventByName] [nvarchar](64) NULL,
	[EventOn] [datetime] NULL,
 CONSTRAINT [PK_AppEnd_ActivityLog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END


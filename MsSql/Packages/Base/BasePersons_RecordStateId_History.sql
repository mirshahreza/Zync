-- =============================================
-- Author:      SMO scripted
-- Create date: 2025-09-28
-- Description: Create table [dbo].[BasePersons_RecordStateId_History] with keys, defaults, and indexes.
-- =============================================
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BasePersons_RecordStateId_History]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[BasePersons_RecordStateId_History](
	[HistoryId] [int] IDENTITY(1,1) NOT NULL,
	[Id] [int] NOT NULL,
	[HistoryBy] [int] NOT NULL,
	[HistoryOn] [datetime] NOT NULL,
	[StateBy] [int] NOT NULL,
	[StateOn] [datetime] NOT NULL,
	[RecordStateId] [varchar](64) NULL,
 CONSTRAINT [PK_BasePersons_RecordStateId_History_HistoryId] PRIMARY KEY CLUSTERED 
(
	[HistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[BasePersons_RecordStateId_History]  WITH CHECK ADD  CONSTRAINT [BasePersons_RecordStateId_History_Id_BasePersons_Id] FOREIGN KEY([Id])
REFERENCES [dbo].[BasePersons] ([Id])
GO

ALTER TABLE [dbo].[BasePersons_RecordStateId_History] CHECK CONSTRAINT [BasePersons_RecordStateId_History_Id_BasePersons_Id]
GO



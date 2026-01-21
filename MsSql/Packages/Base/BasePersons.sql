-- =============================================
-- Author:      SMO scripted
-- Create date: 2025-09-28
-- Description: Create table [dbo].[BasePersons] with keys, defaults, and indexes.
-- =============================================
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BasePersons]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[BasePersons](
	[Id] [int] IDENTITY(100000000,1) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[EntityTypeId] [varchar](16) NULL,
	[RecordStateId] [varchar](16) NULL,
	[RecordStateIdUpdatedBy] [int] NULL,
	[RecordStateIdUpdatedOn] [datetime] NULL,
	[UserId] [int] NULL,
	[NationalCode] [varchar](16) NULL,
	[Title] [nvarchar](128) NULL,
	[GenderId] [varchar](16) NULL,
	[FirstName] [nvarchar](64) NULL,
	[LastName] [nvarchar](64) NULL,
	[BirthYear] [int] NULL,
	[BirthMonth] [tinyint] NULL,
	[BirthDay] [tinyint] NULL,
	[Mobile] [varchar](16) NOT NULL,
	[LandPhone] [varchar](16) NULL,
	[Picture_FileBody] [image] NULL,
	[Picture_FileBody_xs] [image] NULL,
	[Picture_FileName] [nvarchar](128) NULL,
	[Picture_FileSize] [int] NULL,
	[Picture_FileMime] [varchar](128) NULL,
	
 CONSTRAINT [PK_BasePersons] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END


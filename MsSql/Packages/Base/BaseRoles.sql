-- =============================================
-- Author:      SMO scripted
-- Create date: 2025-09-28
-- Description: Create table [dbo].[BaseRoles] with keys, defaults, and indexes.
-- =============================================
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BaseRoles]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[BaseRoles](
	[Id] [int] IDENTITY(100,1) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[IsBuiltIn] [bit] NULL,
	[RoleName] [nvarchar](64) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Note] [nvarchar](256) NULL,
 CONSTRAINT [PK_AppEnd_Roles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AppEnd_Roles_IsBuiltIn_Default]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[BaseRoles] ADD  CONSTRAINT [AppEnd_Roles_IsBuiltIn_Default]  DEFAULT ('0') FOR [IsBuiltIn]
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_AAA_Roles_IsActive]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[BaseRoles] ADD  CONSTRAINT [DF_AAA_Roles_IsActive]  DEFAULT ('1') FOR [IsActive]
END



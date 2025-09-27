-- =============================================
-- Author:      SMO scripted
-- Create date: 2025-09-28
-- Description: Create table [dbo].[BaseUser] with keys, defaults, and indexes.
-- =============================================
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BaseUser]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[BaseUser](
	[Id] [int] IDENTITY(100000,1) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[IsBuiltIn] [bit] NOT NULL,
	[UserName] [nvarchar](64) NOT NULL,
	[Email] [varchar](64) NULL,
	[EmailVerifiedOn] [datetime] NULL,
	[Mobile] [varchar](14) NULL,
	[MobileVerifiedOn] [datetime] NULL,
	[OTP] [varchar](8) NULL,
	[ExpiredOn] [datetime] NULL,
	[Password] [varchar](256) NULL,
	[PasswordUpdatedBy] [int] NULL,
	[PasswordUpdatedOn] [datetime] NULL,
	[IsActive] [bit] NOT NULL,
	[IsActiveUpdatedBy] [int] NULL,
	[IsActiveUpdatedOn] [datetime] NULL,
	[LoginLocked] [bit] NOT NULL,
	[LoginLockedUpdatedBy] [int] NULL,
	[LoginLockedUpdatedOn] [datetime] NULL,
	[LoginTryFailsCount] [int] NULL,
	[LoginTryFailLastOn] [datetime] NULL,
	[LoginTrySuccessesCount] [int] NULL,
	[LoginTrySuccessLastOn] [datetime] NULL,
	[Settings] [ntext] NULL,
 CONSTRAINT [PK_AppEnd_Users] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IsBuiltIn_Default]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[BaseUser] ADD  CONSTRAINT [IsBuiltIn_Default]  DEFAULT ('0') FOR [IsBuiltIn]
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IsActive_Default]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[BaseUser] ADD  CONSTRAINT [IsActive_Default]  DEFAULT ('1') FOR [IsActive]
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LoginLocked_Default]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[BaseUser] ADD  CONSTRAINT [LoginLocked_Default]  DEFAULT ('0') FOR [LoginLocked]
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LoginFailed_Default]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[BaseUser] ADD  CONSTRAINT [LoginFailed_Default]  DEFAULT ('0') FOR [LoginTryFailsCount]
END



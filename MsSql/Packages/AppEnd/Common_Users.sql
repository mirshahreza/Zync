-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2024-03-31
-- Description:	Contains user account information, including credentials, profile details, and security-related fields. This is the central table for user management.
-- =============================================
CREATE TABLE [DBO].[Common_Users](
	[Id] [int] IDENTITY(100000,1) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[IsBuiltIn] [bit] NOT NULL,
	[UserName] [nvarchar](64) NOT NULL,
	[Email] [varchar](64) NULL,
	[Mobile] [varchar](14) NULL,
	[Picture_FileBody] [image] NULL,
	[Picture_FileBody_xs] [image] NULL,
	[Picture_FileName] [nvarchar](128) NULL,
	[Picture_FileSize] [int] NULL,
	[Picture_FileMime] [varchar](32) NULL,
	[Password] [varchar](256) NULL,
	[PasswordUpdatedBy] [int] NULL,
	[PasswordUpdatedOn] [datetime] NULL,
	[IsActive] [bit] NOT NULL,
	[IsActiveUpdatedBy] [int] NULL,
	[IsActiveUpdatedOn] [datetime] NULL,
	[LoginLocked] [bit] NOT NULL,
	[LoginLockedUpdatedBy] [int] NULL,
	[LoginLockedUpdatedOn] [datetime] NULL,
	[LoginTryFails] [int] NULL,
	[LoginTryFailLastOn] [datetime] NULL,
	[LoginTrySuccesses] [int] NULL,
	[LoginTrySuccessLastOn] [datetime] NULL,
	[Settings] [ntext] NULL,
 CONSTRAINT [PK_Common_Users] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];

ALTER TABLE [DBO].[Common_Users] ADD  CONSTRAINT [IsBuiltIn_Default]  DEFAULT ('0') FOR [IsBuiltIn];

ALTER TABLE [DBO].[Common_Users] ADD  CONSTRAINT [IsActive_Default]  DEFAULT ('1') FOR [IsActive];

ALTER TABLE [DBO].[Common_Users] ADD  CONSTRAINT [LoginLocked_Default]  DEFAULT ('0') FOR [LoginLocked];

ALTER TABLE [DBO].[Common_Users] ADD  CONSTRAINT [LoginFailed_Default]  DEFAULT ('0') FOR [LoginTryFails];

INSERT INTO Common_Users	
		(IsBuiltIn,UserName,Email,Mobile,[Password],IsActive,LoginLocked,Settings,CreatedBy,CreatedOn) 
VALUES	(1,'admin','youremail@yourdomain.com','','D7B91B6A9FA705E968B2C859FDDE9457',1,0,'{}',10000,GETDATE());

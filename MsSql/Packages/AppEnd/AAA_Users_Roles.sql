-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2024-03-31
-- Description:	Table to hold roles of users - AppEnd LowCode system
-- =============================================
CREATE TABLE [DBO].[AAA_Users_Roles](
	[Id] [int] IDENTITY(1000000,1) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[UserId] [int] NOT NULL,
	[RoleId] [int] NOT NULL,
 CONSTRAINT [PK_AppEnd_Users_Roles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY];

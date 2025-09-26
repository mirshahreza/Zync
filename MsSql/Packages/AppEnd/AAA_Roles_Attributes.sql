-- =============================================
-- Author:		Mohsen Mirshahreza
-- Create date: 2024-08-07
-- Description:	Table to hold additional attributes for roles 
-- =============================================
CREATE TABLE [dbo].[AAA_Roles_Attributes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RoleId] [int] NOT NULL,
	[AttributeId] [int] NOT NULL,
 CONSTRAINT [PK_AAA_Roles_Attributes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


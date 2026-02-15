-- =============================================
-- Name:        ElsaBookmarks
-- Description: Elsa 3.5.3 Bookmarks table for SQL Server
-- Generated for AppEnd integration
-- =============================================
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'ElsaBookmarks')
BEGIN
    CREATE TABLE [dbo].[ElsaBookmarks]
    (
        [Id] NVARCHAR(450) NOT NULL,
        [InstanceId] NVARCHAR(450) NOT NULL,
        [ActivityInstanceId] NVARCHAR(450) NULL,
        [ActivityType] NVARCHAR(450) NOT NULL,
        [Hash] NVARCHAR(450) NOT NULL,
        [Metadata] NVARCHAR(MAX) NULL,
        [CreatedAt] DATETIMEOFFSET NOT NULL,
        [Data] NVARCHAR(MAX) NULL,
        [TenantId] NVARCHAR(450) NULL,
        PRIMARY KEY CLUSTERED ([Id] ASC)
    )
END

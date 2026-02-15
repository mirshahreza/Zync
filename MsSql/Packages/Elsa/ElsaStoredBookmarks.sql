-- =============================================
-- Name:        ElsaStoredBookmarks
-- Description: Elsa 3.5.3 StoredBookmarks table for SQL Server (for persistence of trigger data)
-- Generated for AppEnd integration
-- =============================================
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'ElsaStoredBookmarks')
BEGIN
    CREATE TABLE [dbo].[ElsaStoredBookmarks]
    (
        [Id] NVARCHAR(450) NOT NULL,
        [BookmarkId] NVARCHAR(450) NOT NULL,
        [ActivityType] NVARCHAR(450) NOT NULL,
        [SerializedData] NVARCHAR(MAX) NULL,
        [CreatedAt] DATETIMEOFFSET NOT NULL,
        PRIMARY KEY CLUSTERED ([Id] ASC)
    )
END

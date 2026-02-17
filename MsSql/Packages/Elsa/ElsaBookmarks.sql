-- ==================================================================================
-- Elsa Bookmarks
-- ==================================================================================

SET NOCOUNT ON;

DROP TABLE IF EXISTS [dbo].[ElsaBookmarks];

CREATE TABLE [dbo].[ElsaBookmarks]
(
    [Id] NVARCHAR(255) PRIMARY KEY NOT NULL,
    [WorkflowInstanceId] NVARCHAR(255) NOT NULL,
    [ActivityId] NVARCHAR(255) NOT NULL,
    [ActivityType] NVARCHAR(255) NOT NULL,
    [Name] NVARCHAR(255) NOT NULL,
    [Hash] NVARCHAR(255),
    [Payload] NVARCHAR(MAX), -- JSON bookmark data
    [Metadata] NVARCHAR(MAX), -- Additional metadata
    [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [ResumableFrom] DATETIME2,
    [IsProcessed] BIT NOT NULL DEFAULT 0,
    [ProcessedAt] DATETIME2,
    FOREIGN KEY ([WorkflowInstanceId]) REFERENCES [dbo].[ElsaWorkflowInstances]([Id]) ON DELETE CASCADE,
    INDEX [IX_Bookmarks_WorkflowInstanceId] NONCLUSTERED ([WorkflowInstanceId]),
    INDEX [IX_Bookmarks_ActivityId] NONCLUSTERED ([ActivityId]),
    INDEX [IX_Bookmarks_Hash] NONCLUSTERED ([Hash]),
    INDEX [IX_Bookmarks_IsProcessed] NONCLUSTERED ([IsProcessed])
);

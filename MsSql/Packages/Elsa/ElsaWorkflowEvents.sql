-- ==================================================================================
-- Elsa Workflow Events
-- ==================================================================================

SET NOCOUNT ON;

DROP TABLE IF EXISTS [dbo].[ElsaWorkflowEvents];

CREATE TABLE [dbo].[ElsaWorkflowEvents]
(
    [Id] NVARCHAR(255) PRIMARY KEY NOT NULL,
    [WorkflowInstanceId] NVARCHAR(255) NOT NULL,
    [EventName] NVARCHAR(255) NOT NULL,
    [Source] NVARCHAR(255), -- Activity or system
    [Payload] NVARCHAR(MAX), -- JSON
    [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [ProcessedAt] DATETIME2,
    [IsProcessed] BIT NOT NULL DEFAULT 0,
    FOREIGN KEY ([WorkflowInstanceId]) REFERENCES [dbo].[ElsaWorkflowInstances]([Id]) ON DELETE CASCADE,
    INDEX [IX_WorkflowEvents_WorkflowInstanceId] NONCLUSTERED ([WorkflowInstanceId]),
    INDEX [IX_WorkflowEvents_EventName] NONCLUSTERED ([EventName]),
    INDEX [IX_WorkflowEvents_IsProcessed] NONCLUSTERED ([IsProcessed])
);

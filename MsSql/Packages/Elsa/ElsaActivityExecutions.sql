-- ==================================================================================
-- Elsa Activity Executions
-- ==================================================================================

SET NOCOUNT ON;

DROP TABLE IF EXISTS [dbo].[ElsaActivityExecutions];

CREATE TABLE [dbo].[ElsaActivityExecutions]
(
    [Id] NVARCHAR(255) PRIMARY KEY NOT NULL,
    [WorkflowInstanceId] NVARCHAR(255) NOT NULL,
    [ActivityId] NVARCHAR(255) NOT NULL, -- Activity type (e.g., 'WriteLine', 'Delay', etc.)
    [ActivityType] NVARCHAR(255) NOT NULL,
    [DisplayName] NVARCHAR(500),
    [Status] NVARCHAR(50) NOT NULL DEFAULT 'Pending', -- Pending, Running, Completed, Faulted, Suspended
    [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [StartedAt] DATETIME2,
    [CompletedAt] DATETIME2,
    [FaultedAt] DATETIME2,
    [Outputs] NVARCHAR(MAX), -- JSON activity output
    [ExceptionMessage] NVARCHAR(MAX),
    [ExecutionLog] NVARCHAR(MAX),
    [Sequence] INT,
    FOREIGN KEY ([WorkflowInstanceId]) REFERENCES [dbo].[ElsaWorkflowInstances]([Id]) ON DELETE CASCADE,
    INDEX [IX_ActivityExecutions_WorkflowInstanceId] NONCLUSTERED ([WorkflowInstanceId]),
    INDEX [IX_ActivityExecutions_Status] NONCLUSTERED ([Status]),
    INDEX [IX_ActivityExecutions_CreatedAt] NONCLUSTERED ([CreatedAt])
);

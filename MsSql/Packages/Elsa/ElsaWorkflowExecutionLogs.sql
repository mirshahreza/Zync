-- ==================================================================================
-- Elsa Workflow Execution Logs
-- ==================================================================================

SET NOCOUNT ON;

DROP TABLE IF EXISTS [dbo].[ElsaWorkflowExecutionLogs];

CREATE TABLE [dbo].[ElsaWorkflowExecutionLogs]
(
    [Id] NVARCHAR(255) PRIMARY KEY NOT NULL,
    [WorkflowInstanceId] NVARCHAR(255) NOT NULL,
    [ActivityExecutionId] NVARCHAR(255),
    [EventName] NVARCHAR(255) NOT NULL, -- 'WorkflowStarted', 'ActivityCompleted', etc.
    [Message] NVARCHAR(MAX),
    [Level] NVARCHAR(50) NOT NULL DEFAULT 'Information', -- Information, Warning, Error
    [Timestamp] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [Data] NVARCHAR(MAX), -- JSON additional data
    [UserId] NVARCHAR(255),
    [CorrelationId] NVARCHAR(255),
    FOREIGN KEY ([WorkflowInstanceId]) REFERENCES [dbo].[ElsaWorkflowInstances]([Id]) ON DELETE CASCADE,
    INDEX [IX_WorkflowExecutionLogs_WorkflowInstanceId] NONCLUSTERED ([WorkflowInstanceId]),
    INDEX [IX_WorkflowExecutionLogs_EventName] NONCLUSTERED ([EventName]),
    INDEX [IX_WorkflowExecutionLogs_Timestamp] NONCLUSTERED ([Timestamp]),
    INDEX [IX_WorkflowExecutionLogs_Level] NONCLUSTERED ([Level])
);

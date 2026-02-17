-- ==================================================================================
-- Elsa Execution Contexts
-- ==================================================================================

SET NOCOUNT ON;

DROP TABLE IF EXISTS [dbo].[ElsaExecutionContexts];

CREATE TABLE [dbo].[ElsaExecutionContexts]
(
    [Id] NVARCHAR(255) PRIMARY KEY NOT NULL,
    [WorkflowInstanceId] NVARCHAR(255) NOT NULL,
    [ActivityExecutionId] NVARCHAR(255),
    [ContextType] NVARCHAR(255) NOT NULL, -- 'Workflow', 'Activity', 'Decision'
    [Data] NVARCHAR(MAX), -- JSON context data
    [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [ExpiresAt] DATETIME2,
    FOREIGN KEY ([WorkflowInstanceId]) REFERENCES [dbo].[ElsaWorkflowInstances]([Id]) ON DELETE CASCADE,
    INDEX [IX_ExecutionContexts_WorkflowInstanceId] NONCLUSTERED ([WorkflowInstanceId])
);

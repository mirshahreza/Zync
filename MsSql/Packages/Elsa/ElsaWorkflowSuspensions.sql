-- ==================================================================================
-- Elsa Workflow Suspensions
-- ==================================================================================

SET NOCOUNT ON;

DROP TABLE IF EXISTS [dbo].[ElsaWorkflowSuspensions];

CREATE TABLE [dbo].[ElsaWorkflowSuspensions]
(
    [Id] NVARCHAR(255) PRIMARY KEY NOT NULL,
    [WorkflowInstanceId] NVARCHAR(255) NOT NULL,
    [Reason] NVARCHAR(255),
    [SuspendedBy] NVARCHAR(255),
    [SuspendedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [ResumedBy] NVARCHAR(255),
    [ResumedAt] DATETIME2,
    [Notes] NVARCHAR(MAX),
    FOREIGN KEY ([WorkflowInstanceId]) REFERENCES [dbo].[ElsaWorkflowInstances]([Id]) ON DELETE CASCADE,
    INDEX [IX_WorkflowSuspensions_WorkflowInstanceId] NONCLUSTERED ([WorkflowInstanceId]),
    INDEX [IX_WorkflowSuspensions_SuspendedAt] NONCLUSTERED ([SuspendedAt])
);

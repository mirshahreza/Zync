-- ==================================================================================
-- Elsa Workflow Instances
-- ==================================================================================

SET NOCOUNT ON;

DROP TABLE IF EXISTS [dbo].[ElsaActivityExecutions];
DROP TABLE IF EXISTS [dbo].[ElsaBookmarks];
DROP TABLE IF EXISTS [dbo].[ElsaWorkflowExecutionLogs];
DROP TABLE IF EXISTS [dbo].[ElsaVariableInstances];
DROP TABLE IF EXISTS [dbo].[ElsaTriggeredWorkflows];
DROP TABLE IF EXISTS [dbo].[ElsaWorkflowEvents];
DROP TABLE IF EXISTS [dbo].[ElsaWorkflowTriggers];
DROP TABLE IF EXISTS [dbo].[ElsaExecutionContexts];
DROP TABLE IF EXISTS [dbo].[ElsaApprovalInstances];
DROP TABLE IF EXISTS [dbo].[ElsaWorkflowSuspensions];
DROP TABLE IF EXISTS [dbo].[ElsaAuditLogs];
DROP TABLE IF EXISTS [dbo].[ElsaWorkflowInstances];

CREATE TABLE [dbo].[ElsaWorkflowInstances]
(
    [Id] NVARCHAR(255) PRIMARY KEY NOT NULL,
    [WorkflowDefinitionId] NVARCHAR(255) NOT NULL,
    [WorkflowDefinitionVersionId] NVARCHAR(255),
    [CorrelationId] NVARCHAR(255),
    [Status] NVARCHAR(50) NOT NULL DEFAULT 'Running', -- Running, Suspended, Faulted, Finished, Cancelled
    [SubStatus] NVARCHAR(50),
    [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [StartedAt] DATETIME2,
    [ResumedAt] DATETIME2,
    [CompletedAt] DATETIME2,
    [FaultedAt] DATETIME2,
    [CancelledAt] DATETIME2,
    [ExceptionMessage] NVARCHAR(MAX),
    [Variables] NVARCHAR(MAX), -- JSON variables
    [CustomAttributes] NVARCHAR(MAX),
    [TenantId] NVARCHAR(255),
    [UserId] NVARCHAR(255),
    [Input] NVARCHAR(MAX), -- Initial input
    [Output] NVARCHAR(MAX), -- Final output
    [Fault] NVARCHAR(MAX), -- Fault details
    [IsDeleted] BIT NOT NULL DEFAULT 0,
    [DeletedAt] DATETIME2,
    FOREIGN KEY ([WorkflowDefinitionId]) REFERENCES [dbo].[ElsaWorkflowDefinitions]([Id]) ON DELETE CASCADE,
    INDEX [IX_WorkflowInstances_WorkflowDefinitionId] NONCLUSTERED ([WorkflowDefinitionId]),
    INDEX [IX_WorkflowInstances_Status] NONCLUSTERED ([Status]),
    INDEX [IX_WorkflowInstances_CorrelationId] NONCLUSTERED ([CorrelationId]),
    INDEX [IX_WorkflowInstances_CreatedAt] NONCLUSTERED ([CreatedAt]),
    INDEX [IX_WorkflowInstances_TenantId] NONCLUSTERED ([TenantId])
);

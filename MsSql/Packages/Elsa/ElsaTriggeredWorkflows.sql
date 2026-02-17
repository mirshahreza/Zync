-- ==================================================================================
-- Elsa Triggered Workflows
-- ==================================================================================

SET NOCOUNT ON;

DROP TABLE IF EXISTS [dbo].[ElsaTriggeredWorkflows];

CREATE TABLE [dbo].[ElsaTriggeredWorkflows]
(
    [Id] NVARCHAR(255) PRIMARY KEY NOT NULL,
    [WorkflowDefinitionId] NVARCHAR(255) NOT NULL,
    [WorkflowDefinitionVersionId] NVARCHAR(255),
    [TriggerType] NVARCHAR(255) NOT NULL, -- 'Timer', 'Event', 'Webhook', etc.
    [TriggerName] NVARCHAR(255),
    [IsActive] BIT NOT NULL DEFAULT 1,
    [Payload] NVARCHAR(MAX), -- Trigger configuration
    [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [UpdatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    FOREIGN KEY ([WorkflowDefinitionId]) REFERENCES [dbo].[ElsaWorkflowDefinitions]([Id]) ON DELETE CASCADE,
    INDEX [IX_TriggeredWorkflows_WorkflowDefinitionId] NONCLUSTERED ([WorkflowDefinitionId]),
    INDEX [IX_TriggeredWorkflows_TriggerType] NONCLUSTERED ([TriggerType]),
    INDEX [IX_TriggeredWorkflows_IsActive] NONCLUSTERED ([IsActive])
);

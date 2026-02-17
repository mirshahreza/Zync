-- ==================================================================================
-- Elsa Workflow Triggers
-- ==================================================================================

SET NOCOUNT ON;

DROP TABLE IF EXISTS [dbo].[ElsaWorkflowTriggers];

CREATE TABLE [dbo].[ElsaWorkflowTriggers]
(
    [Id] NVARCHAR(255) PRIMARY KEY NOT NULL,
    [WorkflowDefinitionId] NVARCHAR(255) NOT NULL,
    [ActivityId] NVARCHAR(255) NOT NULL,
    [ActivityType] NVARCHAR(255) NOT NULL,
    [Name] NVARCHAR(255),
    [Hash] NVARCHAR(255),
    [Payload] NVARCHAR(MAX), -- JSON
    [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    FOREIGN KEY ([WorkflowDefinitionId]) REFERENCES [dbo].[ElsaWorkflowDefinitions]([Id]) ON DELETE CASCADE,
    INDEX [IX_WorkflowTriggers_WorkflowDefinitionId] NONCLUSTERED ([WorkflowDefinitionId]),
    INDEX [IX_WorkflowTriggers_ActivityType] NONCLUSTERED ([ActivityType])
);

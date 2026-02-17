-- ==================================================================================
-- Elsa Workflow Definition Versions
-- ==================================================================================

SET NOCOUNT ON;

DROP TABLE IF EXISTS [dbo].[ElsaWorkflowDefinitionVersions];

CREATE TABLE [dbo].[ElsaWorkflowDefinitionVersions]
(
    [Id] NVARCHAR(255) PRIMARY KEY NOT NULL,
    [WorkflowDefinitionId] NVARCHAR(255) NOT NULL,
    [Version] INT NOT NULL,
    [Data] NVARCHAR(MAX) NOT NULL, -- JSON definition
    [IsPublished] BIT NOT NULL DEFAULT 0,
    [PublishedAt] DATETIME2,
    [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [CreatedBy] NVARCHAR(255),
    [CustomAttributes] NVARCHAR(MAX), -- Custom metadata
    [Hash] NVARCHAR(255), -- For detecting changes
    FOREIGN KEY ([WorkflowDefinitionId]) REFERENCES [dbo].[ElsaWorkflowDefinitions]([Id]) ON DELETE CASCADE,
    INDEX [IX_WorkflowDefinitionVersions_WorkflowDefinitionId] NONCLUSTERED ([WorkflowDefinitionId]),
    INDEX [IX_WorkflowDefinitionVersions_Version] NONCLUSTERED ([WorkflowDefinitionId], [Version])
);

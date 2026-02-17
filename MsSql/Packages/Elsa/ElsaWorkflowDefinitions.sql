-- ==================================================================================
-- Elsa Workflow Definitions
-- ==================================================================================

SET NOCOUNT ON;

-- Disable FK constraints temporarily
ALTER TABLE IF EXISTS [dbo].[ElsaWorkflowInstances] NOCHECK CONSTRAINT ALL;

DROP TABLE IF EXISTS [dbo].[ElsaWorkflowDefinitionVersions];
DROP TABLE IF EXISTS [dbo].[ElsaWorkflowInstances];
DROP TABLE IF EXISTS [dbo].[ElsaWorkflowDefinitions];

CREATE TABLE [dbo].[ElsaWorkflowDefinitions]
(
    [Id] NVARCHAR(255) PRIMARY KEY NOT NULL,
    [Name] NVARCHAR(255) NOT NULL,
    [DisplayName] NVARCHAR(500),
    [Description] NVARCHAR(MAX),
    [Version] INT NOT NULL DEFAULT 1,
    [PublishedVersion] INT,
    [IsPublished] BIT NOT NULL DEFAULT 0,
    [IsPaused] BIT NOT NULL DEFAULT 0,
    [DefinitionFormat] NVARCHAR(50) NOT NULL DEFAULT 'Json', -- 'Json' or 'CodeFirst'
    [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [UpdatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [CreatedBy] NVARCHAR(255),
    [UpdatedBy] NVARCHAR(255),
    [TenantId] NVARCHAR(255),
    [IsDeleted] BIT NOT NULL DEFAULT 0,
    [DeletedAt] DATETIME2,
    INDEX [IX_WorkflowDefinitions_Name] NONCLUSTERED ([Name]),
    INDEX [IX_WorkflowDefinitions_TenantId] NONCLUSTERED ([TenantId]),
    INDEX [IX_WorkflowDefinitions_IsPublished] NONCLUSTERED ([IsPublished]),
    INDEX [IX_WorkflowDefinitions_CreatedAt] NONCLUSTERED ([CreatedAt])
);

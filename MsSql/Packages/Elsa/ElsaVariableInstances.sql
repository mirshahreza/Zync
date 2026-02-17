-- ==================================================================================
-- Elsa Variable Instances
-- ==================================================================================

SET NOCOUNT ON;

DROP TABLE IF EXISTS [dbo].[ElsaVariableInstances];

CREATE TABLE [dbo].[ElsaVariableInstances]
(
    [Id] NVARCHAR(255) PRIMARY KEY NOT NULL,
    [WorkflowInstanceId] NVARCHAR(255) NOT NULL,
    [Name] NVARCHAR(255) NOT NULL,
    [Value] NVARCHAR(MAX), -- JSON
    [Type] NVARCHAR(255), -- Data type (int, string, object, etc.)
    [IsVolatile] BIT NOT NULL DEFAULT 0, -- Is it persistable?
    [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [UpdatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    FOREIGN KEY ([WorkflowInstanceId]) REFERENCES [dbo].[ElsaWorkflowInstances]([Id]) ON DELETE CASCADE,
    INDEX [IX_VariableInstances_WorkflowInstanceId] NONCLUSTERED ([WorkflowInstanceId]),
    INDEX [IX_VariableInstances_Name] NONCLUSTERED ([WorkflowInstanceId], [Name])
);

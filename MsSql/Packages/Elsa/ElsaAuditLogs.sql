-- ==================================================================================
-- Elsa Audit Logs
-- ==================================================================================

SET NOCOUNT ON;

DROP TABLE IF EXISTS [dbo].[ElsaAuditLogs];

CREATE TABLE [dbo].[ElsaAuditLogs]
(
    [Id] NVARCHAR(255) PRIMARY KEY NOT NULL,
    [EntityType] NVARCHAR(255) NOT NULL, -- WorkflowDefinition, WorkflowInstance, etc.
    [EntityId] NVARCHAR(255) NOT NULL,
    [Action] NVARCHAR(50) NOT NULL, -- Create, Update, Delete, Execute, etc.
    [Changes] NVARCHAR(MAX), -- JSON changes
    [ChangedBy] NVARCHAR(255),
    [ChangedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [IpAddress] NVARCHAR(50),
    [TenantId] NVARCHAR(255),
    INDEX [IX_AuditLogs_EntityType] NONCLUSTERED ([EntityType]),
    INDEX [IX_AuditLogs_EntityId] NONCLUSTERED ([EntityId]),
    INDEX [IX_AuditLogs_ChangedAt] NONCLUSTERED ([ChangedAt])
);

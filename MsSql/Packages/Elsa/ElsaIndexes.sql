-- =============================================
-- Name:        ElsaIndexes
-- Description: Elsa 3.5.3 indexes for better query performance
-- Generated for AppEnd integration
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_ElsaWorkflowDefinitions_DefinitionId' AND object_id = OBJECT_ID(N'[dbo].[ElsaWorkflowDefinitions]'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_ElsaWorkflowDefinitions_DefinitionId ON [dbo].[ElsaWorkflowDefinitions]([DefinitionVersionId])
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_ElsaWorkflowInstances_DefinitionId' AND object_id = OBJECT_ID(N'[dbo].[ElsaWorkflowInstances]'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_ElsaWorkflowInstances_DefinitionId ON [dbo].[ElsaWorkflowInstances]([DefinitionId])
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_ElsaWorkflowInstances_DefinitionVersionId' AND object_id = OBJECT_ID(N'[dbo].[ElsaWorkflowInstances]'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_ElsaWorkflowInstances_DefinitionVersionId ON [dbo].[ElsaWorkflowInstances]([DefinitionVersionId])
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_ElsaBookmarks_InstanceId' AND object_id = OBJECT_ID(N'[dbo].[ElsaBookmarks]'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_ElsaBookmarks_InstanceId ON [dbo].[ElsaBookmarks]([InstanceId])
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_ElsaBookmarks_Hash' AND object_id = OBJECT_ID(N'[dbo].[ElsaBookmarks]'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_ElsaBookmarks_Hash ON [dbo].[ElsaBookmarks]([Hash])
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_ElsaWorkflowExecutionLogRecords_InstanceId' AND object_id = OBJECT_ID(N'[dbo].[ElsaWorkflowExecutionLogRecords]'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_ElsaWorkflowExecutionLogRecords_InstanceId ON [dbo].[ElsaWorkflowExecutionLogRecords]([InstanceId])
END

PRINT 'Elsa 3.5.3 schema created successfully in [dbo] with Elsa prefix.'

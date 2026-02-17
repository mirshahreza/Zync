-- ==================================================================================
-- Elsa Indexes and Constraints
-- ==================================================================================

SET NOCOUNT ON;

-- ==================================================================================
-- Add Unique Constraint for Workflow Name
-- ==================================================================================

-- Only add if table and columns exist
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'ElsaWorkflowDefinitions')
    AND EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('[dbo].[ElsaWorkflowDefinitions]') AND name IN ('Name', 'TenantId'))
BEGIN
    IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'UC_WorkflowDefinitions_Name_TenantId')
    BEGIN
        ALTER TABLE [dbo].[ElsaWorkflowDefinitions]
        ADD CONSTRAINT [UC_WorkflowDefinitions_Name_TenantId] 
        UNIQUE NONCLUSTERED ([Name], [TenantId]);
    END
END

-- ==================================================================================
-- Additional Indexes for Performance
-- ==================================================================================

-- Only add if table and column exist
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'ElsaWorkflowInstances')
    AND EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('[dbo].[ElsaWorkflowInstances]') AND name = 'CorrelationId')
BEGIN
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_ElsaWorkflowInstances_CorrelationId')
    BEGIN
        CREATE NONCLUSTERED INDEX [IX_ElsaWorkflowInstances_CorrelationId]
        ON [dbo].[ElsaWorkflowInstances]([CorrelationId]);
    END
END

PRINT ' -> Elsa indexes configuration completed.';



-- ==================================================================================
-- Elsa Recently Modified Workflows
-- ==================================================================================

CREATE OR ALTER VIEW [dbo].[ElsaRecentlyModifiedWorkflows] AS
SELECT TOP 20
    [Name],
    [DisplayName],
    [Version],
    [UpdatedAt],
    [UpdatedBy],
    [IsPublished]
FROM [dbo].[ElsaWorkflowDefinitions]
WHERE [IsDeleted] = 0
ORDER BY [UpdatedAt] DESC;

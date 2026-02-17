-- ==================================================================================
-- Elsa Workflow Definitions Status
-- ==================================================================================

CREATE OR ALTER VIEW [dbo].[ElsaWorkflowDefinitionsStatus] AS
SELECT 
    [Name],
    [DisplayName],
    [Version],
    [PublishedVersion],
    [IsPublished],
    [IsPaused],
    [DefinitionFormat],
    [CreatedAt],
    [UpdatedAt],
    [CreatedBy]
FROM [dbo].[ElsaWorkflowDefinitions]
WHERE [IsDeleted] = 0
ORDER BY [UpdatedAt] DESC;

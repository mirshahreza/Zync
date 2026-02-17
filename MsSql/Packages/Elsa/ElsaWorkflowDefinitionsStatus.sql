-- ==================================================================================
-- Elsa Workflow Definitions Status
-- ==================================================================================

GO
CREATE OR ALTER VIEW [dbo].[ElsaWorkflowDefinitionsStatus] AS
SELECT TOP 1000000
    wd.[Id],
    wd.[Name],
    wd.[DisplayName],
    wd.[Version],
    wd.[IsPublished],
    wd.[IsPaused],
    COUNT(DISTINCT wi.[Id]) AS [InstanceCount],
    SUM(CASE WHEN wi.[Status] = 'Running' THEN 1 ELSE 0 END) AS [RunningInstances],
    SUM(CASE WHEN wi.[Status] = 'Faulted' THEN 1 ELSE 0 END) AS [FaultedInstances],
    wd.[UpdatedAt]
FROM [dbo].[ElsaWorkflowDefinitions] wd
LEFT JOIN [dbo].[ElsaWorkflowInstances] wi ON wd.[Id] = wi.[WorkflowDefinitionId]
WHERE wd.[IsDeleted] = 0
GROUP BY wd.[Id], wd.[Name], wd.[DisplayName], wd.[Version], wd.[IsPublished], wd.[IsPaused], wd.[UpdatedAt]
ORDER BY wd.[UpdatedAt] DESC;
GO

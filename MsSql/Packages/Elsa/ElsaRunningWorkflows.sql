-- ==================================================================================
-- Elsa Running Workflows
-- ==================================================================================

CREATE OR ALTER VIEW [dbo].[ElsaRunningWorkflows] AS
SELECT TOP 100
    wi.[Id],
    wd.[Name] AS [WorkflowName],
    wi.[Status],
    wi.[CreatedAt],
    wi.[StartedAt],
    DATEDIFF(HOUR, wi.[StartedAt], GETUTCDATE()) AS [RunningHours],
    wi.[UserId],
    wi.[TenantId]
FROM [dbo].[ElsaWorkflowInstances] wi
LEFT JOIN [dbo].[ElsaWorkflowDefinitions] wd ON wi.[WorkflowDefinitionId] = wd.[Id]
WHERE wi.[Status] = 'Running'
    AND wi.[IsDeleted] = 0
ORDER BY wi.[StartedAt] DESC;

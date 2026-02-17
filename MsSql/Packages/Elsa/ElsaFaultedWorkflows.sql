-- ==================================================================================
-- Elsa Faulted Workflows
-- ==================================================================================

CREATE OR ALTER VIEW [dbo].[ElsaFaultedWorkflows] AS
SELECT TOP 50
    wi.[Id],
    wd.[Name] AS [WorkflowName],
    wi.[Status],
    wi.[FaultedAt],
    wi.[ExceptionMessage],
    wi.[UserId]
FROM [dbo].[ElsaWorkflowInstances] wi
LEFT JOIN [dbo].[ElsaWorkflowDefinitions] wd ON wi.[WorkflowDefinitionId] = wd.[Id]
WHERE wi.[Status] = 'Faulted'
    AND wi.[IsDeleted] = 0
ORDER BY wi.[FaultedAt] DESC;

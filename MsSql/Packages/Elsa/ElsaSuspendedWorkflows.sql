-- ==================================================================================
-- Elsa Suspended Workflows
-- ==================================================================================
CREATE OR ALTER VIEW [dbo].[ElsaSuspendedWorkflows] AS
SELECT TOP 1000000
    ws.[Id],
    wi.[Id] AS [WorkflowInstanceId],
    wd.[Name] AS [WorkflowName],
    ws.[Reason],
    ws.[SuspendedBy],
    ws.[SuspendedAt],
    DATEDIFF(HOUR, ws.[SuspendedAt], GETUTCDATE()) AS [SuspendedHours],
    ws.[Notes]
FROM [dbo].[ElsaWorkflowSuspensions] ws
LEFT JOIN [dbo].[ElsaWorkflowInstances] wi ON ws.[WorkflowInstanceId] = wi.[Id]
LEFT JOIN [dbo].[ElsaWorkflowDefinitions] wd ON wi.[WorkflowDefinitionId] = wd.[Id]
WHERE ws.[ResumedAt] IS NULL
ORDER BY ws.[SuspendedAt] DESC;


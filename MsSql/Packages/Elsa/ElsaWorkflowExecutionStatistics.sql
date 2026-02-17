-- ==================================================================================
-- Elsa Workflow Execution Statistics
-- ==================================================================================

CREATE OR ALTER VIEW [dbo].[ElsaWorkflowExecutionStatistics] AS
SELECT 
    wd.[Name] AS [WorkflowName],
    COUNT(wi.[Id]) AS [TotalInstances],
    SUM(CASE WHEN wi.[Status] = 'Running' THEN 1 ELSE 0 END) AS [Running],
    SUM(CASE WHEN wi.[Status] = 'Completed' THEN 1 ELSE 0 END) AS [Completed],
    SUM(CASE WHEN wi.[Status] = 'Faulted' THEN 1 ELSE 0 END) AS [Faulted],
    SUM(CASE WHEN wi.[Status] = 'Suspended' THEN 1 ELSE 0 END) AS [Suspended],
    AVG(DATEDIFF(MINUTE, wi.[StartedAt], ISNULL(wi.[CompletedAt], GETUTCDATE()))) AS [AvgDurationMinutes]
FROM [dbo].[ElsaWorkflowDefinitions] wd
LEFT JOIN [dbo].[ElsaWorkflowInstances] wi ON wd.[Id] = wi.[WorkflowDefinitionId]
WHERE wd.[IsDeleted] = 0
GROUP BY wd.[Name]
ORDER BY [TotalInstances] DESC;

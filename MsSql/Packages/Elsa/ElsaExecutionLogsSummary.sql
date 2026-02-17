-- ==================================================================================
-- Elsa Execution Logs Summary
-- ==================================================================================

CREATE OR ALTER VIEW [dbo].[ElsaExecutionLogsSummary] AS
SELECT TOP 100
    [WorkflowInstanceId],
    [EventName],
    COUNT(*) AS [Count],
    MAX([Timestamp]) AS [LastOccurrence]
FROM [dbo].[ElsaWorkflowExecutionLogs]
WHERE [Timestamp] >= DATEADD(DAY, -1, GETUTCDATE())
GROUP BY [WorkflowInstanceId], [EventName]
ORDER BY [LastOccurrence] DESC;
GO

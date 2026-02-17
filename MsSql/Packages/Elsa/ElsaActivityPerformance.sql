-- ==================================================================================
-- Elsa Activity Performance
-- ==================================================================================

CREATE OR ALTER VIEW [dbo].[ElsaActivityPerformance] AS
SELECT TOP 50
    [ActivityType],
    COUNT(*) AS [ExecutionCount],
    AVG(DATEDIFF(MILLISECOND, [StartedAt], [CompletedAt])) AS [AvgDurationMs],
    SUM(CASE WHEN [Status] = 'Completed' THEN 1 ELSE 0 END) AS [Successful],
    SUM(CASE WHEN [Status] = 'Faulted' THEN 1 ELSE 0 END) AS [Failed]
FROM [dbo].[ElsaActivityExecutions]
WHERE [StartedAt] IS NOT NULL
    AND [CompletedAt] IS NOT NULL
GROUP BY [ActivityType]
ORDER BY [ExecutionCount] DESC;

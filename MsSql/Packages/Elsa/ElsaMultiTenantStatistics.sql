-- ==================================================================================
-- Elsa Multi-Tenant Statistics
-- ==================================================================================

CREATE OR ALTER VIEW [dbo].[ElsaMultiTenantStatistics] AS
SELECT 
    ISNULL([TenantId], 'Default') AS [TenantId],
    COUNT(DISTINCT [Id]) AS [WorkflowCount],
    SUM(CASE WHEN [Status] = 'Running' THEN 1 ELSE 0 END) AS [RunningCount],
    SUM(CASE WHEN [Status] = 'Completed' THEN 1 ELSE 0 END) AS [CompletedCount]
FROM [dbo].[ElsaWorkflowInstances]
WHERE [IsDeleted] = 0
GROUP BY [TenantId]
ORDER BY [WorkflowCount] DESC;

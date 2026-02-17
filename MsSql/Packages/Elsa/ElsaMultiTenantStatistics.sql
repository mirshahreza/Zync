-- ==================================================================================
-- Elsa Multi-Tenant Statistics
-- ==================================================================================

GO
CREATE OR ALTER VIEW [dbo].[ElsaMultiTenantStatistics] AS
SELECT TOP 1000000
    wi.[TenantId],
    COUNT(DISTINCT wi.[Id]) AS [TotalInstances],
    SUM(CASE WHEN wi.[Status] = 'Running' THEN 1 ELSE 0 END) AS [RunningInstances],
    SUM(CASE WHEN wi.[Status] = 'Finished' THEN 1 ELSE 0 END) AS [FinishedInstances],
    SUM(CASE WHEN wi.[Status] = 'Faulted' THEN 1 ELSE 0 END) AS [FaultedInstances],
    AVG(DATEDIFF(MINUTE, wi.[CreatedAt], COALESCE(wi.[CompletedAt], GETUTCDATE()))) AS [AvgDurationMinutes],
    MAX(wi.[CreatedAt]) AS [LastInstanceCreatedAt]
FROM [dbo].[ElsaWorkflowInstances] wi
WHERE wi.[IsDeleted] = 0
GROUP BY wi.[TenantId]
ORDER BY [TotalInstances] DESC;
GO

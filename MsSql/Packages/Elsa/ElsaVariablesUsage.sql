-- ==================================================================================
-- Elsa Variables Usage
-- ==================================================================================

CREATE OR ALTER VIEW [dbo].[ElsaVariablesUsage] AS
SELECT TOP 100
    [Name] AS [VariableName],
    COUNT(*) AS [UsageCount],
    MIN([CreatedAt]) AS [FirstUsed],
    MAX([CreatedAt]) AS [LastUsed],
    COUNT(DISTINCT [WorkflowInstanceId]) AS [DistinctWorkflows]
FROM [dbo].[ElsaVariableInstances]
GROUP BY [Name]
ORDER BY [UsageCount] DESC;
GO

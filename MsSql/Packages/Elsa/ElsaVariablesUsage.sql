-- ==================================================================================
-- Elsa Variables Usage
-- ==================================================================================

CREATE OR ALTER VIEW [dbo].[ElsaVariablesUsage] AS
SELECT TOP 100
    [Name],
    [Type],
    COUNT(DISTINCT [WorkflowInstanceId]) AS [UsageCount],
    SUM(CASE WHEN [IsVolatile] = 1 THEN 1 ELSE 0 END) AS [VolatileCount]
FROM [dbo].[ElsaVariableInstances]
GROUP BY [Name], [Type]
ORDER BY [UsageCount] DESC;

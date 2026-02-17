-- ==================================================================================
-- Elsa Workflow Status Overview
-- ==================================================================================
CREATE OR ALTER VIEW [dbo].[ElsaWorkflowStatusOverview] AS
    SELECT 
        [Status],
        COUNT(*) AS [Count],
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM [dbo].[ElsaWorkflowInstances]) AS [Percentage]
    FROM [dbo].[ElsaWorkflowInstances]
    WHERE [IsDeleted] = 0
    GROUP BY [Status]
    ORDER BY [Count] DESC
    OFFSET 0 ROWS;

-- ==================================================================================
-- Elsa Workflow Status Overview
-- ==================================================================================

-- Only create view if the required table exists
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'ElsaWorkflowInstances')
BEGIN
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
END
ELSE
BEGIN
    PRINT ' -> ElsaWorkflowInstances table does not exist yet. View will be created later.';
END

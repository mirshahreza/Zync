-- =============================================
-- Name:        ElsaWorkflowTaskStats
-- Description: Elsa 3.5.3 View for workflow task statistics
-- Generated for AppEnd integration
-- =============================================
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID(N'[dbo].[ElsaWorkflowTaskStats]', N'V') IS NOT NULL
    DROP VIEW [dbo].[ElsaWorkflowTaskStats];
GO

CREATE VIEW [dbo].[ElsaWorkflowTaskStats]
AS
SELECT 
    [DefinitionId],
    COUNT(*) AS [TotalTasks],
    SUM(CASE WHEN [Status] = 'Pending' THEN 1 ELSE 0 END) AS [PendingCount],
    SUM(CASE WHEN [Status] = 'Completed' THEN 1 ELSE 0 END) AS [CompletedCount],
    SUM(CASE WHEN [Status] = 'Cancelled' THEN 1 ELSE 0 END) AS [CancelledCount],
    SUM(CASE WHEN [DueDate] < GETUTCDATE() AND [Status] = 'Pending' THEN 1 ELSE 0 END) AS [OverdueCount],
    AVG(CASE WHEN [CompletedAt] IS NOT NULL THEN DATEDIFF(HOUR, [CreatedAt], [CompletedAt]) ELSE NULL END) AS [AvgCompletionTimeHours]
FROM [dbo].[ElsaWorkflowTasks]
GROUP BY [DefinitionId];
GO

PRINT 'View ElsaWorkflowTaskStats created successfully!';
GO

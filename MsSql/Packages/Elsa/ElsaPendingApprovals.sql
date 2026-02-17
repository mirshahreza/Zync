-- ==================================================================================
-- Elsa Pending Approvals
-- ==================================================================================

CREATE OR ALTER VIEW [dbo].[ElsaPendingApprovals] AS
SELECT TOP 100
    ap.[Id],
    ap.[Title],
    ap.[Description],
    ap.[RequestedBy],
    ap.[RequestedFor],
    ap.[Status],
    ap.[DueDate],
    DATEDIFF(DAY, GETUTCDATE(), ap.[DueDate]) AS [DaysRemaining],
    wi.[CorrelationId]
FROM [dbo].[ElsaApprovalInstances] ap
LEFT JOIN [dbo].[ElsaWorkflowInstances] wi ON ap.[WorkflowInstanceId] = wi.[Id]
WHERE ap.[Status] = 'Pending'
    AND ap.[DueDate] >= GETUTCDATE()
ORDER BY ap.[DueDate] ASC;

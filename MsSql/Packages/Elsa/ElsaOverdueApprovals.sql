-- ==================================================================================
-- Elsa Overdue Approvals
-- ==================================================================================
CREATE OR ALTER VIEW [dbo].[ElsaOverdueApprovals] AS
SELECT TOP 1000000
    ap.[Id],
    ap.[Title],
    ap.[RequestedFor],
    ap.[DueDate],
    DATEDIFF(DAY, ap.[DueDate], GETUTCDATE()) AS [DaysOverdue],
    ap.[ReminderSent]
FROM [dbo].[ElsaApprovalInstances] ap
WHERE ap.[Status] = 'Pending'
    AND ap.[DueDate] < GETUTCDATE()
ORDER BY [DaysOverdue] DESC;


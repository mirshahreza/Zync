-- =============================================
-- Name:        ElsaMyPendingTasks
-- Description: Elsa 3.5.3 View for pending workflow tasks
-- Generated for AppEnd integration
-- =============================================
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID(N'[dbo].[vw_ElsaMyPendingTasks]', N'V') IS NOT NULL
    DROP VIEW [dbo].[vw_ElsaMyPendingTasks];
GO

CREATE VIEW [dbo].[vw_ElsaMyPendingTasks]
AS
SELECT 
    t.[Id],
    t.[InstanceId],
    t.[DefinitionId],
    t.[Title],
    t.[Description],
    t.[Priority],
    t.[DueDate],
    t.[CreatedAt],
    t.[AssignedTo],
    t.[AssignedRole],
    t.[ContextData],
    CASE 
        WHEN t.[DueDate] IS NOT NULL AND t.[DueDate] < GETUTCDATE() 
        THEN 1 
        ELSE 0 
    END AS [IsOverdue],
    DATEDIFF(DAY, GETUTCDATE(), t.[DueDate]) AS [DaysRemaining]
FROM [dbo].[ElsaWorkflowTasks] t
WHERE t.[Status] = 'Pending' AND t.[TenantId] IS NOT NULL;
GO

PRINT 'View vw_ElsaMyPendingTasks created successfully!';
GO

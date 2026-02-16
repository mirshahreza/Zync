-- =============================================
-- Name:        ElsaGetMyWorkflowTasks
-- Description: Elsa 3.5.3 Stored Procedure to retrieve user workflow tasks
-- Generated for AppEnd integration
-- =============================================
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE OR ALTER PROCEDURE [dbo].[ElsaGetMyWorkflowTasks]
    @UserId NVARCHAR(100),
    @Status NVARCHAR(50) = NULL,
    @Page INT = 1,
    @PageSize INT = 25
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Offset INT = (@Page - 1) * @PageSize;

    SELECT 
        t.[Id],
        t.[InstanceId],
        t.[DefinitionId],
        t.[Title],
        t.[Description],
        t.[Priority],
        t.[Status],
        t.[DueDate],
        t.[CreatedAt],
        t.[AssignedTo],
        t.[AssignedRole],
        t.[ContextData],
        CASE 
            WHEN t.[DueDate] IS NOT NULL AND t.[DueDate] < GETUTCDATE() AND t.[Status] = 'Pending'
            THEN 1 
            ELSE 0 
        END AS [IsOverdue]
    FROM [dbo].[ElsaWorkflowTasks] t
    WHERE 
        (t.[AssignedTo] = @UserId OR t.[AssignedTo] IS NULL)
        AND (@Status IS NULL OR t.[Status] = @Status)
    ORDER BY 
        t.[Priority] DESC,
        t.[CreatedAt] DESC
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;

    -- Return total count
    SELECT COUNT(*) AS [TotalCount]
    FROM [dbo].[ElsaWorkflowTasks] t
    WHERE 
        (t.[AssignedTo] = @UserId OR t.[AssignedTo] IS NULL)
        AND (@Status IS NULL OR t.[Status] = @Status);
END;


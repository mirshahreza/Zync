-- =============================================
-- Name:        ElsaCompleteWorkflowTask
-- Description: Elsa 3.5.3 Stored Procedure to complete a workflow task
-- Generated for AppEnd integration
-- =============================================
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID(N'[dbo].[sp_ElsaCompleteWorkflowTask]', N'P') IS NOT NULL
    DROP PROCEDURE [dbo].[sp_ElsaCompleteWorkflowTask];
GO

CREATE PROCEDURE [dbo].[sp_ElsaCompleteWorkflowTask]
    @TaskId UNIQUEIDENTIFIER,
    @UserId NVARCHAR(100),
    @Outcome NVARCHAR(100),
    @Comment NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate task exists and is pending
    IF NOT EXISTS (SELECT 1 FROM [dbo].[ElsaWorkflowTasks] WHERE [Id] = @TaskId AND [Status] = 'Pending')
    BEGIN
        RAISERROR('Task not found or already completed', 16, 1);
        RETURN;
    END

    -- Update task
    UPDATE [dbo].[ElsaWorkflowTasks]
    SET 
        [Status] = 'Completed',
        [CompletedAt] = GETUTCDATE(),
        [CompletedBy] = @UserId,
        [Outcome] = @Outcome,
        [Comment] = @Comment,
        [ModifiedAt] = GETUTCDATE(),
        [ModifiedBy] = @UserId
    WHERE [Id] = @TaskId;

    -- Return updated task
    SELECT 
        [Id],
        [InstanceId],
        [BookmarkId],
        [Outcome],
        [CompletedAt]
    FROM [dbo].[ElsaWorkflowTasks]
    WHERE [Id] = @TaskId;
END;
GO

PRINT 'Stored procedure sp_ElsaCompleteWorkflowTask created successfully!';
GO

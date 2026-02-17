-- ==================================================================================
-- Elsa Approval Instances
-- ==================================================================================

SET NOCOUNT ON;

DROP TABLE IF EXISTS [dbo].[ElsaApprovalInstances];

CREATE TABLE [dbo].[ElsaApprovalInstances]
(
    [Id] NVARCHAR(255) PRIMARY KEY NOT NULL,
    [WorkflowInstanceId] NVARCHAR(255) NOT NULL,
    [ActivityExecutionId] NVARCHAR(255) NOT NULL,
    [RequestedBy] NVARCHAR(255) NOT NULL,
    [RequestedFor] NVARCHAR(255) NOT NULL,
    [Title] NVARCHAR(500),
    [Description] NVARCHAR(MAX),
    [Status] NVARCHAR(50) NOT NULL DEFAULT 'Pending', -- Pending, Approved, Rejected, Escalated
    [ApprovedBy] NVARCHAR(255),
    [ApprovedAt] DATETIME2,
    [RejectionReason] NVARCHAR(MAX),
    [DueDate] DATETIME2,
    [ReminderSent] BIT NOT NULL DEFAULT 0,
    [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [UpdatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    FOREIGN KEY ([WorkflowInstanceId]) REFERENCES [dbo].[ElsaWorkflowInstances]([Id]) ON DELETE CASCADE,
    INDEX [IX_ApprovalInstances_WorkflowInstanceId] NONCLUSTERED ([WorkflowInstanceId]),
    INDEX [IX_ApprovalInstances_Status] NONCLUSTERED ([Status]),
    INDEX [IX_ApprovalInstances_RequestedFor] NONCLUSTERED ([RequestedFor]),
    INDEX [IX_ApprovalInstances_DueDate] NONCLUSTERED ([DueDate])
);

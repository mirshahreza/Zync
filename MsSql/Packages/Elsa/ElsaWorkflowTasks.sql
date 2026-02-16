-- =============================================
-- Name:        ElsaWorkflowTasks
-- Description: Elsa 3.5.3 WorkflowTasks table for SQL Server
-- Generated for AppEnd integration
-- =============================================
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'ElsaWorkflowTasks')
BEGIN
    CREATE TABLE [dbo].[ElsaWorkflowTasks]
    (
        [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
        [InstanceId] NVARCHAR(450) NOT NULL,
        [DefinitionId] NVARCHAR(450) NOT NULL,
        [BookmarkId] NVARCHAR(450) NULL,
        [Title] NVARCHAR(500) NOT NULL,
        [Description] NVARCHAR(MAX) NULL,
        [AssignedTo] NVARCHAR(100) NULL,
        [AssignedRole] NVARCHAR(100) NULL,
        [Priority] NVARCHAR(50) NOT NULL DEFAULT 'Normal',
        [Status] NVARCHAR(50) NOT NULL DEFAULT 'Pending',
        [DueDate] DATETIMEOFFSET NULL,
        [CreatedAt] DATETIMEOFFSET NOT NULL,
        [CompletedAt] DATETIMEOFFSET NULL,
        [CompletedBy] NVARCHAR(100) NULL,
        [Outcome] NVARCHAR(100) NULL,
        [Comment] NVARCHAR(MAX) NULL,
        [ContextData] NVARCHAR(MAX) NULL,
        [CreatedBy] NVARCHAR(100) NULL,
        [ModifiedAt] DATETIMEOFFSET NULL,
        [ModifiedBy] NVARCHAR(100) NULL,
        [TenantId] NVARCHAR(450) NULL
    )
END

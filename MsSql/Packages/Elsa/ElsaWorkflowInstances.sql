-- =============================================
-- Name:        ElsaWorkflowInstances
-- Description: Elsa 3.5.3 WorkflowInstances table for SQL Server
-- Generated for AppEnd integration
-- =============================================
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'ElsaWorkflowInstances')
BEGIN
    CREATE TABLE [dbo].[ElsaWorkflowInstances]
    (
        [Id] NVARCHAR(450) NOT NULL,
        [DefinitionId] NVARCHAR(450) NOT NULL,
        [DefinitionVersionId] NVARCHAR(450) NOT NULL,
        [TenantId] NVARCHAR(450) NULL,
        [ParentId] NVARCHAR(450) NULL,
        [Status] NVARCHAR(50) NOT NULL,
        [SubStatus] NVARCHAR(50) NULL,
        [CorrelationId] NVARCHAR(450) NULL,
        [CreatedAt] DATETIMEOFFSET NOT NULL,
        [StartedAt] DATETIMEOFFSET NULL,
        [FinishedAt] DATETIMEOFFSET NULL,
        [UpdatedAt] DATETIMEOFFSET NULL,
        [CancelledAt] DATETIMEOFFSET NULL,
        [SerializedProperties] NVARCHAR(MAX) NULL,
        [SerializedData] NVARCHAR(MAX) NULL,
        PRIMARY KEY CLUSTERED ([Id] ASC)
    )
END

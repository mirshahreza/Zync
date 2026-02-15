-- =============================================
-- Name:        ElsaWorkflowDefinitions
-- Description: Elsa 3.5.3 WorkflowDefinitions table for SQL Server
-- Generated for AppEnd integration
-- =============================================
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'ElsaWorkflowDefinitions')
BEGIN
    CREATE TABLE [dbo].[ElsaWorkflowDefinitions]
    (
        [Id] NVARCHAR(450) NOT NULL,
        [Name] NVARCHAR(255) NULL,
        [Description] NVARCHAR(MAX) NULL,
        [CreatedAt] DATETIMEOFFSET NOT NULL,
        [UpdatedAt] DATETIMEOFFSET NULL,
        [PublishedAt] DATETIMEOFFSET NULL,
        [Version] INT NOT NULL,
        [IsLatest] BIT NOT NULL,
        [IsPublished] BIT NOT NULL,
        [TenantId] NVARCHAR(450) NULL,
        [Data] NVARCHAR(MAX) NULL,
        [HashValue] NVARCHAR(MAX) NULL,
        [IsReadonly] BIT NOT NULL,
        [ToolVersion] INT NULL,
        [DefinitionVersionId] NVARCHAR(450) NOT NULL,
        PRIMARY KEY CLUSTERED ([Id] ASC)
    )
END

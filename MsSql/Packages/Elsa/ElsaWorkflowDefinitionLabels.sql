-- =============================================
-- Name:        ElsaWorkflowDefinitionLabels
-- Description: Elsa 3.5.3 WorkflowDefinitionLabels table for SQL Server
-- Generated for AppEnd integration
-- =============================================
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'ElsaWorkflowDefinitionLabels')
BEGIN
    CREATE TABLE [dbo].[ElsaWorkflowDefinitionLabels]
    (
        [Id] NVARCHAR(450) NOT NULL,
        [DefinitionId] NVARCHAR(450) NOT NULL,
        [LabelId] NVARCHAR(450) NOT NULL,
        PRIMARY KEY CLUSTERED ([Id] ASC)
    )
END

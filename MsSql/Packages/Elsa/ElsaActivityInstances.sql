-- =============================================
-- Name:        ElsaActivityInstances
-- Description: Elsa 3.5.3 ActivityInstances table for SQL Server
-- Generated for AppEnd integration
-- =============================================
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'ElsaActivityInstances')
BEGIN
    CREATE TABLE [dbo].[ElsaActivityInstances]
    (
        [Id] NVARCHAR(450) NOT NULL,
        [InstanceId] NVARCHAR(450) NOT NULL,
        [ActivityId] NVARCHAR(450) NOT NULL,
        [ActivityType] NVARCHAR(450) NOT NULL,
        [ActivityName] NVARCHAR(450) NULL,
        [StartedAt] DATETIMEOFFSET NULL,
        [FinishedAt] DATETIMEOFFSET NULL,
        [Status] NVARCHAR(50) NOT NULL,
        [SerializedProperties] NVARCHAR(MAX) NULL,
        [SerializedData] NVARCHAR(MAX) NULL,
        [ExecutionLogId] NVARCHAR(450) NULL,
        PRIMARY KEY CLUSTERED ([Id] ASC)
    )
END

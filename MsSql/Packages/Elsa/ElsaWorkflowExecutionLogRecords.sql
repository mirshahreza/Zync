-- =============================================
-- Name:        ElsaWorkflowExecutionLogRecords
-- Description: Elsa 3.5.3 WorkflowExecutionLogRecords table for SQL Server
-- Generated for AppEnd integration
-- =============================================
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'ElsaWorkflowExecutionLogRecords')
BEGIN
    CREATE TABLE [dbo].[ElsaWorkflowExecutionLogRecords]
    (
        [Id] NVARCHAR(450) NOT NULL,
        [InstanceId] NVARCHAR(450) NOT NULL,
        [ActivityInstanceId] NVARCHAR(450) NULL,
        [Timestamp] DATETIMEOFFSET NOT NULL,
        [EventName] NVARCHAR(450) NOT NULL,
        [Message] NVARCHAR(MAX) NULL,
        [LogLevel] NVARCHAR(50) NULL,
        [SerializedData] NVARCHAR(MAX) NULL,
        [TenantId] NVARCHAR(450) NULL,
        PRIMARY KEY CLUSTERED ([Id] ASC)
    )
END

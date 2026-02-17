-- Install remaining Elsa components - All-in-one script

SET NOCOUNT ON;
PRINT 'Starting Elsa component installation...';

-- Ensure base tables exist
IF OBJECT_ID('dbo.ElsaWorkflowDefinitions', 'U') IS NULL
BEGIN
    PRINT 'ERROR: Base table ElsaWorkflowDefinitions not found!';
    RETURN;
END

-- Table: ElsaWorkflowDefinitionVersions
CREATE TABLE [dbo].[ElsaWorkflowDefinitionVersions]
(
    [Id] NVARCHAR(255) PRIMARY KEY NOT NULL,
    [WorkflowDefinitionId] NVARCHAR(255) NOT NULL,
    [VersionNumber] INT NOT NULL,
    [Name] NVARCHAR(255),
    [IsPublished] BIT NOT NULL DEFAULT 0,
    [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [Data] NVARCHAR(MAX),
    FOREIGN KEY ([WorkflowDefinitionId]) REFERENCES [dbo].[ElsaWorkflowDefinitions]([Id]) ON DELETE CASCADE,
    INDEX [IX_DefinitionVersions_WorkflowDefinitionId] NONCLUSTERED ([WorkflowDefinitionId])
);
PRINT '✓ Created ElsaWorkflowDefinitionVersions';

-- Table: ElsaActivityExecutions
CREATE TABLE [dbo].[ElsaActivityExecutions]
(
    [Id] NVARCHAR(255) PRIMARY KEY NOT NULL,
    [WorkflowInstanceId] NVARCHAR(255) NOT NULL,
    [ActivityId] NVARCHAR(255) NOT NULL,
    [ActivityType] NVARCHAR(255) NOT NULL,
    [DisplayName] NVARCHAR(500),
    [Status] NVARCHAR(50) NOT NULL DEFAULT 'Pending',
    [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [StartedAt] DATETIME2,
    [CompletedAt] DATETIME2,
    [FaultedAt] DATETIME2,
    [Outputs] NVARCHAR(MAX),
    [ExceptionMessage] NVARCHAR(MAX),
    [ExecutionLog] NVARCHAR(MAX),
    [Sequence] INT,
    FOREIGN KEY ([WorkflowInstanceId]) REFERENCES [dbo].[ElsaWorkflowInstances]([Id]) ON DELETE CASCADE,
    INDEX [IX_ActivityExecutions_WorkflowInstanceId] NONCLUSTERED ([WorkflowInstanceId]),
    INDEX [IX_ActivityExecutions_Status] NONCLUSTERED ([Status]),
    INDEX [IX_ActivityExecutions_CreatedAt] NONCLUSTERED ([CreatedAt])
);
PRINT '✓ Created ElsaActivityExecutions';

-- Table: ElsaBookmarks
CREATE TABLE [dbo].[ElsaBookmarks]
(
    [Id] NVARCHAR(255) PRIMARY KEY NOT NULL,
    [WorkflowInstanceId] NVARCHAR(255),
    [ActivityType] NVARCHAR(255) NOT NULL,
    [ActivityId] NVARCHAR(255),
    [Hash] NVARCHAR(255),
    [Payload] NVARCHAR(MAX),
    [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    INDEX [IX_Bookmarks_WorkflowInstanceId] NONCLUSTERED ([WorkflowInstanceId]),
    INDEX [IX_Bookmarks_ActivityType] NONCLUSTERED ([ActivityType]),
    INDEX [IX_Bookmarks_Hash] NONCLUSTERED ([Hash])
);
PRINT '✓ Created ElsaBookmarks';

-- Final confirmation
PRINT '';
PRINT '========================================';
PRINT 'Core Elsa Tables Successfully Created!';
PRINT '========================================';

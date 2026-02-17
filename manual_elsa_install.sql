-- Manual Elsa Installation Script
-- This installs Elsa directly from local files, bypassing Zync procedure

SET NOCOUNT ON;

-- Clean previous attempts
DELETE FROM dbo.ZyncObjects WHERE ObjectName LIKE '%Elsa%';
DELETE FROM dbo.ZyncPackages WHERE PackageName LIKE 'Elsa%';

PRINT 'Cleaned previous Elsa installations';

-- Create main Elsa package record
DECLARE @ElsaPackageId UNIQUEIDENTIFIER = NEWID();
INSERT INTO [dbo].[ZyncPackages] (PackageId, PackageName, Version, Status, InstallDate)
VALUES (@ElsaPackageId, 'Elsa', 1, 'INSTALLED', GETDATE());

PRINT 'Created Elsa package record';

-- Now install individual components
-- Start with core tables
SET NOCOUNT ON;
EXEC('
CREATE TABLE [dbo].[ElsaWorkflowDefinitions]
(
    [Id] NVARCHAR(255) PRIMARY KEY NOT NULL,
    [Name] NVARCHAR(255) NOT NULL,
    [DisplayName] NVARCHAR(500),
    [Description] NVARCHAR(MAX),
    [Version] INT NOT NULL DEFAULT 1,
    [PublishedVersion] INT,
    [IsPublished] BIT NOT NULL DEFAULT 0,
    [IsPaused] BIT NOT NULL DEFAULT 0,
    [DefinitionFormat] NVARCHAR(50) NOT NULL DEFAULT ''Json'',
    [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [UpdatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [CreatedBy] NVARCHAR(255),
    [UpdatedBy] NVARCHAR(255),
    [TenantId] NVARCHAR(255),
    [IsDeleted] BIT NOT NULL DEFAULT 0,
    [DeletedAt] DATETIME2,
    INDEX [IX_WorkflowDefinitions_Name] NONCLUSTERED ([Name]),
    INDEX [IX_WorkflowDefinitions_TenantId] NONCLUSTERED ([TenantId]),
    INDEX [IX_WorkflowDefinitions_IsPublished] NONCLUSTERED ([IsPublished]),
    INDEX [IX_WorkflowDefinitions_CreatedAt] NONCLUSTERED ([CreatedAt])
);
');

PRINT 'Created ElsaWorkflowDefinitions table';

EXEC('
CREATE TABLE [dbo].[ElsaWorkflowInstances]
(
    [Id] NVARCHAR(255) PRIMARY KEY NOT NULL,
    [WorkflowDefinitionId] NVARCHAR(255) NOT NULL,
    [Status] NVARCHAR(50) NOT NULL DEFAULT ''Pending'',
    [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [StartedAt] DATETIME2,
    [CompletedAt] DATETIME2,
    [SuspendedAt] DATETIME2,
    [SuspendedState] NVARCHAR(MAX),
    [Input] NVARCHAR(MAX),
    [Output] NVARCHAR(MAX),
    [BookmarksJson] NVARCHAR(MAX),
    [CorrelationId] NVARCHAR(255),
    [TenantId] NVARCHAR(255),
    [IsDeleted] BIT NOT NULL DEFAULT 0,
    [DeletedAt] DATETIME2,
    FOREIGN KEY ([WorkflowDefinitionId]) REFERENCES [dbo].[ElsaWorkflowDefinitions]([Id]) ON DELETE CASCADE,
    INDEX [IX_WorkflowInstances_WorkflowDefinitionId] NONCLUSTERED ([WorkflowDefinitionId]),
    INDEX [IX_WorkflowInstances_Status] NONCLUSTERED ([Status]),
    INDEX [IX_WorkflowInstances_CreatedAt] NONCLUSTERED ([CreatedAt]),
    INDEX [IX_WorkflowInstances_CorrelationId] NONCLUSTERED ([CorrelationId])
);
');

PRINT 'Created ElsaWorkflowInstances table';

-- Record successful package and objects
INSERT INTO [dbo].[ZyncObjects] (PackageId, ObjectName, ObjectType, ObjectDefinition)
VALUES 
    (@ElsaPackageId, 'ElsaWorkflowDefinitions', 'TABLE', ''),
    (@ElsaPackageId, 'ElsaWorkflowInstances', 'TABLE', '');

PRINT 'Recorded Elsa core tables in tracking system';
PRINT 'Elsa core installation complete!';

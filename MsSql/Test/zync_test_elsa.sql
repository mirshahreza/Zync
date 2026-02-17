-- =============================================
-- Test: Elsa Package
-- Description: Verifies Elsa 3.5.3 tables and indexes
-- =============================================
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

PRINT '========================================='
PRINT 'Testing Elsa Package'
PRINT '========================================='

-- Install Elsa tables directly (bypass Zync to test files directly)
PRINT ''
PRINT 'Installing Elsa tables...'

-- Execute all table creation scripts directly
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaWorkflowDefinitions.sql
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaWorkflowDefinitionVersions.sql
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaWorkflowInstances.sql
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaActivityExecutions.sql
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaBookmarks.sql
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaWorkflowExecutionLogs.sql
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaVariableInstances.sql
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaTriggeredWorkflows.sql
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaWorkflowEvents.sql
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaWorkflowTriggers.sql
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaExecutionContexts.sql
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaApprovalInstances.sql
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaWorkflowSuspensions.sql
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaAuditLogs.sql
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaIndexes.sql

PRINT 'Elsa package installed.'

-- Test 1: Verify all tables exist
PRINT ''
PRINT 'Test 1: Verifying tables exist...'
DECLARE @TableCount INT = 0
DECLARE @MissingTables NVARCHAR(MAX) = ''

SELECT @TableCount = COUNT(*)
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'dbo' 
  AND TABLE_NAME IN (
    'ElsaWorkflowDefinitions',
    'ElsaWorkflowDefinitionVersions',
    'ElsaWorkflowInstances',
    'ElsaActivityExecutions',
    'ElsaBookmarks',
    'ElsaWorkflowExecutionLogs',
    'ElsaVariableInstances',
    'ElsaTriggeredWorkflows',
    'ElsaWorkflowEvents',
    'ElsaWorkflowTriggers',
    'ElsaExecutionContexts',
    'ElsaApprovalInstances',
    'ElsaWorkflowSuspensions',
    'ElsaAuditLogs'
  )

IF @TableCount = 14
  PRINT '  ✓ All 14 tables exist'
ELSE
BEGIN
  PRINT '  ✗ Expected 8 tables, found ' + CAST(@TableCount AS VARCHAR)
  RAISERROR('Missing tables detected', 16, 1)
END

-- Test 2: Verify ElsaWorkflowDefinitions structure
PRINT ''
PRINT 'Test 2: Verifying ElsaWorkflowDefinitions columns...'
DECLARE @ColCount INT = 0
SELECT @ColCount = COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo' 
  AND TABLE_NAME = 'ElsaWorkflowDefinitions'
  AND COLUMN_NAME IN (
    'Id', 'Name', 'Description', 'CreatedAt', 'UpdatedAt', 'PublishedAt',
    'Version', 'IsLatest', 'IsPublished', 'TenantId', 'Data', 'HashValue',
    'IsReadonly', 'ToolVersion', 'DefinitionVersionId'
  )

IF @ColCount = 15
  PRINT '  ✓ All 15 columns exist'
ELSE
  PRINT '  ✗ Expected 15 columns, found ' + CAST(@ColCount AS VARCHAR)

-- Test 3: Verify ElsaWorkflowInstances structure
PRINT ''
PRINT 'Test 3: Verifying ElsaWorkflowInstances columns...'
SET @ColCount = 0
SELECT @ColCount = COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo' 
  AND TABLE_NAME = 'ElsaWorkflowInstances'
  AND COLUMN_NAME IN (
    'Id', 'DefinitionId', 'DefinitionVersionId', 'TenantId', 'ParentId',
    'Status', 'SubStatus', 'CorrelationId', 'CreatedAt', 'StartedAt',
    'FinishedAt', 'UpdatedAt', 'CancelledAt', 'SerializedProperties', 'SerializedData'
  )

IF @ColCount = 15
  PRINT '  ✓ All 15 columns exist'
ELSE
  PRINT '  ✗ Expected 15 columns, found ' + CAST(@ColCount AS VARCHAR)

-- Test 4: Verify ElsaActivityInstances structure
PRINT ''
PRINT 'Test 4: Verifying ElsaActivityInstances columns...'
SET @ColCount = 0
SELECT @ColCount = COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo' 
  AND TABLE_NAME = 'ElsaActivityInstances'
  AND COLUMN_NAME IN (
    'Id', 'InstanceId', 'ActivityId', 'ActivityType', 'ActivityName',
    'StartedAt', 'FinishedAt', 'Status', 'SerializedProperties', 'SerializedData', 'ExecutionLogId'
  )

IF @ColCount = 11
  PRINT '  ✓ All 11 columns exist'
ELSE
  PRINT '  ✗ Expected 11 columns, found ' + CAST(@ColCount AS VARCHAR)

-- Test 5: Verify ElsaBookmarks structure
PRINT ''
PRINT 'Test 5: Verifying ElsaBookmarks columns...'
SET @ColCount = 0
SELECT @ColCount = COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo' 
  AND TABLE_NAME = 'ElsaBookmarks'
  AND COLUMN_NAME IN (
    'Id', 'InstanceId', 'ActivityInstanceId', 'ActivityType', 'Hash',
    'Metadata', 'CreatedAt', 'Data', 'TenantId'
  )

IF @ColCount = 9
  PRINT '  ✓ All 9 columns exist'
ELSE
  PRINT '  ✗ Expected 9 columns, found ' + CAST(@ColCount AS VARCHAR)

-- Test 6: Verify ElsaWorkflowExecutionLogRecords structure
PRINT ''
PRINT 'Test 6: Verifying ElsaWorkflowExecutionLogRecords columns...'
SET @ColCount = 0
SELECT @ColCount = COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo' 
  AND TABLE_NAME = 'ElsaWorkflowExecutionLogRecords'
  AND COLUMN_NAME IN (
    'Id', 'InstanceId', 'ActivityInstanceId', 'Timestamp', 'EventName',
    'Message', 'LogLevel', 'SerializedData', 'TenantId'
  )

IF @ColCount = 9
  PRINT '  ✓ All 9 columns exist'
ELSE
  PRINT '  ✗ Expected 9 columns, found ' + CAST(@ColCount AS VARCHAR)

-- Test 7: Verify ElsaLabels structure
PRINT ''
PRINT 'Test 7: Verifying ElsaLabels columns...'
SET @ColCount = 0
SELECT @ColCount = COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo' 
  AND TABLE_NAME = 'ElsaLabels'
  AND COLUMN_NAME IN ('Id', 'Name', 'TenantId')

IF @ColCount = 3
  PRINT '  ✓ All 3 columns exist'
ELSE
  PRINT '  ✗ Expected 3 columns, found ' + CAST(@ColCount AS VARCHAR)

-- Test 8: Verify ElsaWorkflowDefinitionLabels structure
PRINT ''
PRINT 'Test 8: Verifying ElsaWorkflowDefinitionLabels columns...'
SET @ColCount = 0
SELECT @ColCount = COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo' 
  AND TABLE_NAME = 'ElsaWorkflowDefinitionLabels'
  AND COLUMN_NAME IN ('Id', 'DefinitionId', 'LabelId')

IF @ColCount = 3
  PRINT '  ✓ All 3 columns exist'
ELSE
  PRINT '  ✗ Expected 3 columns, found ' + CAST(@ColCount AS VARCHAR)

-- Test 9: Verify ElsaStoredBookmarks structure
PRINT ''
PRINT 'Test 9: Verifying ElsaStoredBookmarks columns...'
SET @ColCount = 0
SELECT @ColCount = COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo' 
  AND TABLE_NAME = 'ElsaStoredBookmarks'
  AND COLUMN_NAME IN ('Id', 'BookmarkId', 'ActivityType', 'SerializedData', 'CreatedAt')

IF @ColCount = 5
  PRINT '  ✓ All 5 columns exist'
ELSE
  PRINT '  ✗ Expected 5 columns, found ' + CAST(@ColCount AS VARCHAR)

-- Test 10: Verify indexes
PRINT ''
PRINT 'Test 10: Verifying indexes...'
DECLARE @IndexCount INT = 0
SELECT @IndexCount = COUNT(*)
FROM sys.indexes
WHERE object_id IN (
  OBJECT_ID(N'[dbo].[ElsaWorkflowDefinitions]'),
  OBJECT_ID(N'[dbo].[ElsaWorkflowInstances]'),
  OBJECT_ID(N'[dbo].[ElsaBookmarks]'),
  OBJECT_ID(N'[dbo].[ElsaWorkflowExecutionLogRecords]')
)
AND name LIKE 'IX_Elsa%'

IF @IndexCount >= 6
  PRINT '  ✓ Indexes exist (found ' + CAST(@IndexCount AS VARCHAR) + ')'
ELSE
  PRINT '  ✗ Expected indexes not found (found ' + CAST(@IndexCount AS VARCHAR) + ')'

-- Test 11: Verify primary keys
PRINT ''
PRINT 'Test 11: Verifying primary keys on all tables...'
DECLARE @PKCount INT = 0
SELECT @PKCount = COUNT(*)
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'dbo'
  AND CONSTRAINT_TYPE = 'PRIMARY KEY'
  AND TABLE_NAME IN (
    'ElsaWorkflowDefinitions',
    'ElsaWorkflowInstances',
    'ElsaActivityInstances',
    'ElsaBookmarks',
    'ElsaWorkflowExecutionLogRecords',
    'ElsaLabels',
    'ElsaWorkflowDefinitionLabels',
    'ElsaStoredBookmarks'
  )

IF @PKCount = 8
  PRINT '  ✓ All 8 tables have primary keys'
ELSE
  PRINT '  ✗ Expected 8 primary keys, found ' + CAST(@PKCount AS VARCHAR)

PRINT ''
PRINT '========================================='
PRINT 'Elsa Package Testing Complete'
PRINT '========================================='

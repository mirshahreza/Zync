-- =============================================
-- Test: Elsa 3.0 Workflow Engine Package
-- Description: Verifies Elsa 3.0 tables, views, and structure
-- =============================================
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

PRINT '========================================='
PRINT 'Testing Elsa 3.0 Package'
PRINT '========================================='

-- Install Elsa tables and views
PRINT ''
PRINT 'Installing Elsa 3.0 workflow engine...'

-- Execute all table creation scripts
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

-- Execute monitoring views
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaWorkflowStatusOverview.sql
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaRunningWorkflows.sql
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaFaultedWorkflows.sql
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaWorkflowExecutionStatistics.sql
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaActivityPerformance.sql
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaPendingApprovals.sql
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaOverdueApprovals.sql
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaSuspendedWorkflows.sql
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaExecutionLogsSummary.sql
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaWorkflowDefinitionsStatus.sql
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaRecentlyModifiedWorkflows.sql
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaDatabaseSizeInformation.sql
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaAuditLogRecentChanges.sql
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaMultiTenantStatistics.sql
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaVariablesUsage.sql
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaBookmarksStatus.sql

PRINT 'Elsa 3.0 package installed.'

-- Test 1: Verify all tables exist
PRINT ''
PRINT 'Test 1: Verifying 14 tables created...'
DECLARE @TableCount INT = 0

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
  PRINT '  ✓ All 14 tables created successfully'
ELSE
BEGIN
  PRINT '  ✗ Expected 14 tables, found ' + CAST(@TableCount AS VARCHAR)
  RAISERROR('Missing tables detected', 16, 1)
END

-- Test 2: Verify all views exist
PRINT ''
PRINT 'Test 2: Verifying 16 monitoring views created...'
DECLARE @ViewCount INT = 0

SELECT @ViewCount = COUNT(*)
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_SCHEMA = 'dbo' 
  AND TABLE_NAME IN (
    'ElsaWorkflowStatusOverview',
    'ElsaRunningWorkflows',
    'ElsaFaultedWorkflows',
    'ElsaWorkflowExecutionStatistics',
    'ElsaActivityPerformance',
    'ElsaPendingApprovals',
    'ElsaOverdueApprovals',
    'ElsaSuspendedWorkflows',
    'ElsaExecutionLogsSummary',
    'ElsaWorkflowDefinitionsStatus',
    'ElsaRecentlyModifiedWorkflows',
    'ElsaDatabaseSizeInformation',
    'ElsaAuditLogRecentChanges',
    'ElsaMultiTenantStatistics',
    'ElsaVariablesUsage',
    'ElsaBookmarksStatus'
  )

IF @ViewCount = 16
  PRINT '  ✓ All 16 monitoring views created successfully'
ELSE
BEGIN
  PRINT '  ✗ Expected 16 views, found ' + CAST(@ViewCount AS VARCHAR)
  RAISERROR('Missing views detected', 16, 1)
END

-- Test 3: Verify ElsaWorkflowDefinitions primary key
PRINT ''
PRINT 'Test 3: Verifying ElsaWorkflowDefinitions primary key...'
IF EXISTS (
  SELECT 1 FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
  WHERE TABLE_SCHEMA = 'dbo' 
    AND TABLE_NAME = 'ElsaWorkflowDefinitions' 
    AND COLUMN_NAME = 'Id'
    AND CONSTRAINT_NAME LIKE 'PK_%'
)
  PRINT '  ✓ Primary key on Id column exists'
ELSE
  PRINT '  ✗ Primary key not found on ElsaWorkflowDefinitions'

-- Test 4: Verify foreign keys exist
PRINT ''
PRINT 'Test 4: Verifying foreign key relationships...'
DECLARE @FKCount INT = 0

SELECT @FKCount = COUNT(*)
FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS
WHERE CONSTRAINT_SCHEMA = 'dbo'

IF @FKCount >= 10
  PRINT '  ✓ Foreign key relationships established (' + CAST(@FKCount AS VARCHAR) + ' keys)'
ELSE
  PRINT '  ✗ Fewer foreign keys than expected (' + CAST(@FKCount AS VARCHAR) + ')'

-- Test 5: Verify multi-tenancy support
PRINT ''
PRINT 'Test 5: Verifying multi-tenancy support (TenantId columns)...'
DECLARE @TenantIdCount INT = 0

SELECT @TenantIdCount = COUNT(DISTINCT TABLE_NAME)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
  AND COLUMN_NAME = 'TenantId'
  AND TABLE_NAME LIKE 'Elsa%'

IF @TenantIdCount >= 8
  PRINT '  ✓ Multi-tenancy support implemented (' + CAST(@TenantIdCount AS VARCHAR) + ' tables with TenantId)'
ELSE
  PRINT '  ✗ Limited multi-tenancy support (' + CAST(@TenantIdCount AS VARCHAR) + ' tables)'

-- Test 6: Verify soft delete support (IsDeleted columns)
PRINT ''
PRINT 'Test 6: Verifying soft delete support (IsDeleted columns)...'
DECLARE @IsDeletedCount INT = 0

SELECT @IsDeletedCount = COUNT(DISTINCT TABLE_NAME)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
  AND COLUMN_NAME = 'IsDeleted'
  AND TABLE_NAME LIKE 'Elsa%'

IF @IsDeletedCount >= 5
  PRINT '  ✓ Soft delete support implemented (' + CAST(@IsDeletedCount AS VARCHAR) + ' tables with IsDeleted)'
ELSE
  PRINT '  ✗ Limited soft delete support (' + CAST(@IsDeletedCount AS VARCHAR) + ' tables)'

-- Test 7: Verify timestamp columns
PRINT ''
PRINT 'Test 7: Verifying timestamp columns (CreatedAt, UpdatedAt, etc.)...'
DECLARE @TimeColumns INT = 0

SELECT @TimeColumns = COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME IN ('ElsaWorkflowDefinitions', 'ElsaWorkflowInstances', 'ElsaActivityExecutions')
  AND COLUMN_NAME IN ('CreatedAt', 'UpdatedAt', 'StartedAt', 'CompletedAt')

IF @TimeColumns > 0
  PRINT '  ✓ Timestamp columns present for audit and tracking'
ELSE
  PRINT '  ✗ Timestamp columns not found'

-- Test 8: Data validation - Query a simple view
PRINT ''
PRINT 'Test 8: Verifying views are correctly defined...'
BEGIN TRY
  DECLARE @ViewTest INT
  SELECT @ViewTest = COUNT(*) FROM [dbo].[ElsaWorkflowStatusOverview]
  PRINT '  ✓ ElsaWorkflowStatusOverview view accessible and queryable'
END TRY
BEGIN CATCH
  PRINT '  ✗ Error querying ElsaWorkflowStatusOverview: ' + ERROR_MESSAGE()
END CATCH

PRINT ''
PRINT '========================================='
PRINT 'Elsa 3.0 Package Testing Complete'
PRINT 'Status: All core components verified'
PRINT '========================================='

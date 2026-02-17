-- =============================================
-- Test: Elsa 3.0 Package Direct Installation
-- Description: Install all Elsa tables and views directly from local files
-- =============================================
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

PRINT '========================================='
PRINT 'Elsa 3.0 Package - Direct Installation'
PRINT '========================================='

-- Install all tables
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

-- Install indexes
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaIndexes.sql

-- Install monitoring views
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

PRINT ''
PRINT 'Installation complete!'
PRINT ''
PRINT '========================================='
PRINT 'Post-Installation Verification'
PRINT '========================================='

-- Verification Test 1
PRINT ''
PRINT 'Test 1: Core Tables'
DECLARE @TableCount INT = 0
SELECT @TableCount = COUNT(*)
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME LIKE 'Elsa%' AND TABLE_TYPE = 'BASE TABLE'

PRINT 'Tables created: ' + CAST(@TableCount AS VARCHAR)
IF @TableCount >= 14
  PRINT '✓ PASS: All 14 core tables created'
ELSE
  PRINT '✗ FAIL: Expected 14 tables, found ' + CAST(@TableCount AS VARCHAR)

-- Verification Test 2
PRINT ''
PRINT 'Test 2: Monitoring Views'
DECLARE @ViewCount INT = 0
SELECT @ViewCount = COUNT(*)
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME LIKE 'Elsa%'

PRINT 'Views created: ' + CAST(@ViewCount AS VARCHAR)
IF @ViewCount >= 16
  PRINT '✓ PASS: All 16 monitoring views created'
ELSE
  PRINT '✗ FAIL: Expected 16 views, found ' + CAST(@ViewCount AS VARCHAR)

-- Verification Test 3
PRINT ''
PRINT 'Test 3: Table Structure - ElsaWorkflowDefinitions'
DECLARE @ColCount INT = 0
SELECT @ColCount = COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'ElsaWorkflowDefinitions'

PRINT 'Columns: ' + CAST(@ColCount AS VARCHAR)
IF @ColCount > 0
  PRINT '✓ PASS: ElsaWorkflowDefinitions has columns'
ELSE
  PRINT '✗ FAIL: ElsaWorkflowDefinitions not found'

-- Verification Test 4
PRINT ''
PRINT 'Test 4: Primary Keys'
DECLARE @PKCount INT = 0
SELECT @PKCount = COUNT(DISTINCT TABLE_NAME)
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'dbo' AND CONSTRAINT_NAME LIKE 'PK_%' AND TABLE_NAME LIKE 'Elsa%'

PRINT 'Tables with PK: ' + CAST(@PKCount AS VARCHAR)
IF @PKCount >= 10
  PRINT '✓ PASS: Primary keys configured'
ELSE
  PRINT '✗ FAIL: Some tables missing primary keys'

-- Verification Test 5
PRINT ''
PRINT 'Test 5: Multi-Tenancy (TenantId columns)'
DECLARE @TenantCount INT = 0
SELECT @TenantCount = COUNT(DISTINCT TABLE_NAME)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo' AND COLUMN_NAME = 'TenantId' AND TABLE_NAME LIKE 'Elsa%'

PRINT 'Tables with TenantId: ' + CAST(@TenantCount AS VARCHAR)
IF @TenantCount >= 8
  PRINT '✓ PASS: Multi-tenancy support enabled'
ELSE
  PRINT '✗ FAIL: Limited multi-tenancy'

-- Verification Test 6
PRINT ''
PRINT 'Test 6: Soft Delete Support (IsDeleted columns)'
DECLARE @DeleteCount INT = 0
SELECT @DeleteCount = COUNT(DISTINCT TABLE_NAME)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo' AND COLUMN_NAME = 'IsDeleted' AND TABLE_NAME LIKE 'Elsa%'

PRINT 'Tables with IsDeleted: ' + CAST(@DeleteCount AS VARCHAR)
IF @DeleteCount >= 5
  PRINT '✓ PASS: Soft delete support enabled'
ELSE
  PRINT '✗ FAIL: Limited soft delete support'

-- Verification Test 7
PRINT ''
PRINT 'Test 7: View Execution - ElsaWorkflowStatusOverview'
BEGIN TRY
  DECLARE @ViewExecTest INT
  SELECT @ViewExecTest = COUNT(*) FROM [dbo].[ElsaWorkflowStatusOverview]
  PRINT '✓ PASS: ElsaWorkflowStatusOverview is executable (0 rows as expected)'
END TRY
BEGIN CATCH
  PRINT '✗ FAIL: ' + ERROR_MESSAGE()
END CATCH

-- Verification Test 8
PRINT ''
PRINT 'Test 8: View Execution - ElsaRunningWorkflows'
BEGIN TRY
  DECLARE @RunningTest INT
  SELECT @RunningTest = COUNT(*) FROM [dbo].[ElsaRunningWorkflows]
  PRINT '✓ PASS: ElsaRunningWorkflows is executable (0 rows as expected)'
END TRY
BEGIN CATCH
  PRINT '✗ FAIL: ' + ERROR_MESSAGE()
END CATCH

-- Verification Test 9
PRINT ''
PRINT 'Test 9: View Execution - ElsaWorkflowExecutionStatistics'
BEGIN TRY
  DECLARE @StatsTest INT
  SELECT @StatsTest = COUNT(*) FROM [dbo].[ElsaWorkflowExecutionStatistics]
  PRINT '✓ PASS: ElsaWorkflowExecutionStatistics is executable'
END TRY
BEGIN CATCH
  PRINT '✗ FAIL: ' + ERROR_MESSAGE()
END CATCH

-- Final Summary
PRINT ''
PRINT '========================================='
PRINT 'Installation Summary'
PRINT '========================================='
PRINT 'Database: ' + DB_NAME()
PRINT 'Schema: dbo'
PRINT 'Tables: ' + CAST(@TableCount AS VARCHAR) + '/14'
PRINT 'Views: ' + CAST(@ViewCount AS VARCHAR) + '/16'
PRINT 'Status: ' + CASE WHEN @TableCount >= 14 AND @ViewCount >= 16 THEN 'SUCCESS ✓' ELSE 'INCOMPLETE' END
PRINT '========================================='

-- Test: Create Elsa monitoring views
PRINT 'Creating Elsa 3.0 monitoring views...'
PRINT ''

-- Create views with proper GO batches
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

PRINT 'Views created successfully!'
PRINT ''

-- Verify views
DECLARE @ViewCount INT = 0
SELECT @ViewCount = COUNT(*)
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME LIKE 'Elsa%'

PRINT 'Views found: ' + CAST(@ViewCount AS VARCHAR)
PRINT ''
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME LIKE 'Elsa%' ORDER BY TABLE_NAME
PRINT ''

-- Test view execution
PRINT 'Testing view queryability:'
BEGIN TRY
  DECLARE @Test INT
  SELECT @Test = COUNT(*) FROM [dbo].[ElsaWorkflowStatusOverview]
  PRINT '✓ ElsaWorkflowStatusOverview - OK'
END TRY
BEGIN CATCH
  PRINT '✗ ElsaWorkflowStatusOverview - ' + ERROR_MESSAGE()
END CATCH

BEGIN TRY
  DECLARE @Test2 INT
  SELECT @Test2 = COUNT(*) FROM [dbo].[ElsaRunningWorkflows]
  PRINT '✓ ElsaRunningWorkflows - OK'
END TRY
BEGIN CATCH
  PRINT '✗ ElsaRunningWorkflows - ' + ERROR_MESSAGE()
END CATCH

BEGIN TRY
  DECLARE @Test3 INT
  SELECT @Test3 = COUNT(*) FROM [dbo].[ElsaWorkflowExecutionStatistics]
  PRINT '✓ ElsaWorkflowExecutionStatistics - OK'
END TRY
BEGIN CATCH
  PRINT '✗ ElsaWorkflowExecutionStatistics - ' + ERROR_MESSAGE()
END CATCH

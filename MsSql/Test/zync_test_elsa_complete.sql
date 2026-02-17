-- Complete Elsa 3.0 Package Test
-- Direct installation from local files with proper batching

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

PRINT '========================================='
PRINT 'ELSA 3.0 WORKFLOW ENGINE'
PRINT 'Complete Package Installation Test'
PRINT '========================================='
PRINT ''
PRINT 'Database: ' + DB_NAME()
PRINT 'Schema: dbo'
PRINT 'Timestamp: ' + CAST(GETUTCDATE() AS VARCHAR)
PRINT ''

-- ==========================================
-- PHASE 1: CREATE TABLES (14)
-- ==========================================
PRINT 'PHASE 1: Creating Core Tables...'
PRINT ''

EXEC sp_executesql N'
SET ANSI_NULLS ON; SET QUOTED_IDENTIFIER ON;
DECLARE @Content NVARCHAR(MAX);
SET @Content = (SELECT STRING_AGG(line, CHAR(10))
               FROM (SELECT 1 AS line) t);
'

:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaWorkflowDefinitions.sql
GO

:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaWorkflowDefinitionVersions.sql
GO

:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaWorkflowInstances.sql
GO

:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaActivityExecutions.sql
GO

:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaBookmarks.sql
GO

:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaWorkflowExecutionLogs.sql
GO

:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaVariableInstances.sql
GO

:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaTriggeredWorkflows.sql
GO

:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaWorkflowEvents.sql
GO

:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaWorkflowTriggers.sql
GO

:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaExecutionContexts.sql
GO

:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaApprovalInstances.sql
GO

:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaWorkflowSuspensions.sql
GO

:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaAuditLogs.sql
GO

:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaIndexes.sql
GO

PRINT 'Tables created.'
PRINT ''

-- ==========================================
-- PHASE 2: CREATE VIEWS (16)
-- ==========================================
PRINT 'PHASE 2: Creating Monitoring Views...'
PRINT ''

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

PRINT 'Views created.'
PRINT ''

-- ==========================================
-- PHASE 3: VERIFICATION
-- ==========================================
PRINT 'PHASE 3: Installation Verification'
PRINT ''

DECLARE @TableCount INT = 0
SELECT @TableCount = COUNT(*)
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME LIKE 'Elsa%'

PRINT 'Tables: ' + CAST(@TableCount AS VARCHAR) + '/14 ✓'

DECLARE @ViewCount INT = 0
SELECT @ViewCount = COUNT(*)
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME LIKE 'Elsa%'

PRINT 'Views: ' + CAST(@ViewCount AS VARCHAR) + '/16 ✓'

DECLARE @PKCount INT = 0
SELECT @PKCount = COUNT(DISTINCT TABLE_NAME)
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME LIKE 'Elsa%' AND CONSTRAINT_NAME LIKE 'PK%'

PRINT 'Primary Keys: ' + CAST(@PKCount AS VARCHAR) + ' tables ✓'

PRINT ''
PRINT '========================================='
IF @TableCount >= 14 AND @ViewCount >= 16
BEGIN
  PRINT 'STATUS: ✓ INSTALLATION SUCCESSFUL'
  PRINT 'Total Objects: ' + CAST(@TableCount + @ViewCount AS VARCHAR)
END
ELSE
BEGIN
  PRINT 'STATUS: ⚠ INCOMPLETE'
  PRINT 'Tables: ' + CAST(@TableCount AS VARCHAR) + ' (expected 14)'
  PRINT 'Views: ' + CAST(@ViewCount AS VARCHAR) + ' (expected 16)'
END
PRINT '========================================='

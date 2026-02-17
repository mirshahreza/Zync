-- Install remaining Elsa components from local files
-- This runs all Elsa/*.sql files in the correct dependency order

SET NOCOUNT ON;

DECLARE @BaseDir NVARCHAR(512) = 'c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\';
DECLARE @ElsaPackageId UNIQUEIDENTIFIER;

-- Get the Elsa package ID
SELECT @ElsaPackageId = PackageId FROM dbo.ZyncPackages WHERE PackageName = 'Elsa';

PRINT 'Installing Elsa sub-components from local files...';

-- The order matters due to FK dependencies
-- Objects are below in dependency order

-- 1. Table files (must come first due to FK references)
PRINT '1. Installing ElsaWorkflowDefinitionVersions...';
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaWorkflowDefinitionVersions.sql

PRINT '2. Installing ElsaActivityExecutions...';
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaActivityExecutions.sql

PRINT '3. Installing ElsaBookmarks...';
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaBookmarks.sql

PRINT '4. Installing ElsaWorkflowExecutionLogs...';
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaWorkflowExecutionLogs.sql

PRINT '5. Installing ElsaVariableInstances...';
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaVariableInstances.sql

PRINT '6. Installing ElsaTriggeredWorkflows...';
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaTriggeredWorkflows.sql

PRINT '7. Installing ElsaWorkflowEvents...';
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaWorkflowEvents.sql

PRINT '8. Installing ElsaWorkflowTriggers...';
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaWorkflowTriggers.sql

PRINT '9. Installing ElsaExecutionContexts...';
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaExecutionContexts.sql

PRINT '10. Installing ElsaApprovalInstances...';
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaApprovalInstances.sql

PRINT '11. Installing ElsaWorkflowSuspensions...';
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaWorkflowSuspensions.sql

PRINT '12. Installing ElsaAuditLogs...';
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaAuditLogs.sql

PRINT '13. Installing ElsaIndexes...';
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaIndexes.sql

-- Views can now be created since all tables exist
PRINT '14. Installing ElsaWorkflowStatusOverview...';
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaWorkflowStatusOverview.sql

PRINT '15. Installing ElsaRunningWorkflows...';
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaRunningWorkflows.sql

PRINT '16. Installing ElsaFaultedWorkflows...';
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaFaultedWorkflows.sql

PRINT '17. Installing ElsaWorkflowExecutionStatistics...';
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaWorkflowExecutionStatistics.sql

PRINT '18. Installing ElsaActivityPerformance...';
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaActivityPerformance.sql

PRINT '19. Installing ElsaPendingApprovals...';
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaPendingApprovals.sql

PRINT '20. Installing ElsaOverdueApprovals...';
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaOverdueApprovals.sql

PRINT '21. Installing ElsaSuspendedWorkflows...';
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaSuspendedWorkflows.sql

PRINT '22. Installing ElsaExecutionLogsSummary...';
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaExecutionLogsSummary.sql

PRINT '23. Installing ElsaWorkflowDefinitionsStatus...';
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaWorkflowDefinitionsStatus.sql

PRINT '24. Installing ElsaRecentlyModifiedWorkflows...';
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaRecentlyModifiedWorkflows.sql

PRINT '25. Installing ElsaDatabaseSizeInformation...';
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaDatabaseSizeInformation.sql

PRINT '26. Installing ElsaAuditLogRecentChanges...';
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaAuditLogRecentChanges.sql

PRINT '27. Installing ElsaMultiTenantStatistics...';
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaMultiTenantStatistics.sql

PRINT '28. Installing ElsaVariablesUsage...';
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaVariablesUsage.sql

PRINT '29. Installing ElsaBookmarksStatus...';
:r c:\Workspace\Projects\Zync\MsSql\Packages\Elsa\ElsaBookmarksStatus.sql

PRINT '';
PRINT '========================================';
PRINT 'Elsa Installation Complete!';
PRINT '========================================';
PRINT 'All Elsa tables, views, and indexes have been successfully installed.';

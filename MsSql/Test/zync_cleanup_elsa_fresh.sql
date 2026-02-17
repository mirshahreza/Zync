-- Drop all Elsa views and tables to clean up before reinstall
PRINT 'Cleaning up existing Elsa objects...'

-- Drop views first (they have no dependencies)
IF OBJECT_ID('[dbo].[ElsaWorkflowStatusOverview]', 'V') IS NOT NULL DROP VIEW [dbo].[ElsaWorkflowStatusOverview]
IF OBJECT_ID('[dbo].[ElsaRunningWorkflows]', 'V') IS NOT NULL DROP VIEW [dbo].[ElsaRunningWorkflows]
IF OBJECT_ID('[dbo].[ElsaFaultedWorkflows]', 'V') IS NOT NULL DROP VIEW [dbo].[ElsaFaultedWorkflows]
IF OBJECT_ID('[dbo].[ElsaWorkflowExecutionStatistics]', 'V') IS NOT NULL DROP VIEW [dbo].[ElsaWorkflowExecutionStatistics]
IF OBJECT_ID('[dbo].[ElsaActivityPerformance]', 'V') IS NOT NULL DROP VIEW [dbo].[ElsaActivityPerformance]
IF OBJECT_ID('[dbo].[ElsaPendingApprovals]', 'V') IS NOT NULL DROP VIEW [dbo].[ElsaPendingApprovals]
IF OBJECT_ID('[dbo].[ElsaOverdueApprovals]', 'V') IS NOT NULL DROP VIEW [dbo].[ElsaOverdueApprovals]
IF OBJECT_ID('[dbo].[ElsaSuspendedWorkflows]', 'V') IS NOT NULL DROP VIEW [dbo].[ElsaSuspendedWorkflows]
IF OBJECT_ID('[dbo].[ElsaExecutionLogsSummary]', 'V') IS NOT NULL DROP VIEW [dbo].[ElsaExecutionLogsSummary]
IF OBJECT_ID('[dbo].[ElsaWorkflowDefinitionsStatus]', 'V') IS NOT NULL DROP VIEW [dbo].[ElsaWorkflowDefinitionsStatus]
IF OBJECT_ID('[dbo].[ElsaRecentlyModifiedWorkflows]', 'V') IS NOT NULL DROP VIEW [dbo].[ElsaRecentlyModifiedWorkflows]
IF OBJECT_ID('[dbo].[ElsaDatabaseSizeInformation]', 'V') IS NOT NULL DROP VIEW [dbo].[ElsaDatabaseSizeInformation]
IF OBJECT_ID('[dbo].[ElsaAuditLogRecentChanges]', 'V') IS NOT NULL DROP VIEW [dbo].[ElsaAuditLogRecentChanges]
IF OBJECT_ID('[dbo].[ElsaMultiTenantStatistics]', 'V') IS NOT NULL DROP VIEW [dbo].[ElsaMultiTenantStatistics]
IF OBJECT_ID('[dbo].[ElsaVariablesUsage]', 'V') IS NOT NULL DROP VIEW [dbo].[ElsaVariablesUsage]
IF OBJECT_ID('[dbo].[ElsaBookmarksStatus]', 'V') IS NOT NULL DROP VIEW [dbo].[ElsaBookmarksStatus]

-- Drop tables (in reverse order of dependencies)
IF OBJECT_ID('[dbo].[ElsaAuditLogs]', 'U') IS NOT NULL DROP TABLE [dbo].[ElsaAuditLogs]
IF OBJECT_ID('[dbo].[ElsaWorkflowSuspensions]', 'U') IS NOT NULL DROP TABLE [dbo].[ElsaWorkflowSuspensions]
IF OBJECT_ID('[dbo].[ElsaApprovalInstances]', 'U') IS NOT NULL DROP TABLE [dbo].[ElsaApprovalInstances]
IF OBJECT_ID('[dbo].[ElsaExecutionContexts]', 'U') IS NOT NULL DROP TABLE [dbo].[ElsaExecutionContexts]
IF OBJECT_ID('[dbo].[ElsaWorkflowTriggers]', 'U') IS NOT NULL DROP TABLE [dbo].[ElsaWorkflowTriggers]
IF OBJECT_ID('[dbo].[ElsaWorkflowEvents]', 'U') IS NOT NULL DROP TABLE [dbo].[ElsaWorkflowEvents]
IF OBJECT_ID('[dbo].[ElsaTriggeredWorkflows]', 'U') IS NOT NULL DROP TABLE [dbo].[ElsaTriggeredWorkflows]
IF OBJECT_ID('[dbo].[ElsaVariableInstances]', 'U') IS NOT NULL DROP TABLE [dbo].[ElsaVariableInstances]
IF OBJECT_ID('[dbo].[ElsaWorkflowExecutionLogs]', 'U') IS NOT NULL DROP TABLE [dbo].[ElsaWorkflowExecutionLogs]
IF OBJECT_ID('[dbo].[ElsaBookmarks]', 'U') IS NOT NULL DROP TABLE [dbo].[ElsaBookmarks]
IF OBJECT_ID('[dbo].[ElsaActivityExecutions]', 'U') IS NOT NULL DROP TABLE [dbo].[ElsaActivityExecutions]
IF OBJECT_ID('[dbo].[ElsaWorkflowInstances]', 'U') IS NOT NULL DROP TABLE [dbo].[ElsaWorkflowInstances]
IF OBJECT_ID('[dbo].[ElsaWorkflowDefinitionVersions]', 'U') IS NOT NULL DROP TABLE [dbo].[ElsaWorkflowDefinitionVersions]
IF OBJECT_ID('[dbo].[ElsaWorkflowDefinitions]', 'U') IS NOT NULL DROP TABLE [dbo].[ElsaWorkflowDefinitions]

PRINT 'Cleanup complete'

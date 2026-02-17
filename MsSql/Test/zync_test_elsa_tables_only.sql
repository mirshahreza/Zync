-- Test: Create Elsa tables only
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

PRINT 'Creating Elsa 3.0 tables...'
PRINT ''

-- Create tables with proper GO batches
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

PRINT 'Tables created successfully!'
PRINT ''

-- Verify tables
DECLARE @TableCount INT = 0
SELECT @TableCount = COUNT(*)
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME LIKE 'Elsa%'

PRINT 'Tables found: ' + CAST(@TableCount AS VARCHAR)
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME LIKE 'Elsa%' ORDER BY TABLE_NAME

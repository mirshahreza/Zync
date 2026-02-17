# Elsa 3.0 Workflow Engine - SQL Server Package

**Version:** 3.0  
**Database:** SQL Server 2019+  
**Schema:** dbo  
**Status:** Production Ready

## Overview

Elsa 3.0 Workflow Engine package provides a comprehensive SQL Server database schema for managing workflow definitions, instances, activities, approvals, and audit trails. This package implements best practices for workflow engine architecture with multi-tenancy, soft deletes, comprehensive auditing, and real-time monitoring views.

**Total Package Files:** 32
- **14 Core Tables** with complete workflow engine functionality
- **16 Monitoring/Reporting Views** for real-time insights
- **1 Indexes File** for performance optimization
- **1 Orchestrator File** (Elsa.sql) for automated installation

## Package Contents - Core Tables (14)

| Table | Purpose | Key Features |
|-------|---------|--------------|
| **ElsaWorkflowDefinitions** | Workflow metadata and versions | Multi-tenancy, soft-delete, publishing |
| **ElsaWorkflowDefinitionVersions** | Version history with JSON data | Rollback support, complete definition storage |
| **ElsaWorkflowInstances** | Individual workflow executions | Status tracking, correlation IDs, input/output |
| **ElsaActivityExecutions** | Activity-level execution tracking | Status, timing, outputs, performance metrics |
| **ElsaBookmarks** | Workflow resumption points | Pause/resume capability, event handling |
| **ElsaWorkflowExecutionLogs** | Comprehensive execution audit trail | Events, messages, severity levels, timestamps |
| **ElsaVariableInstances** | Runtime workflow variables | JSON storage, volatile support |
| **ElsaTriggeredWorkflows** | Event-driven workflow triggers | Timer, event, webhook configurations |
| **ElsaWorkflowEvents** | Workflow instance events | Event names, sources, payloads |
| **ElsaWorkflowTriggers** | Activity trigger configurations | Hashing, linking to activities |
| **ElsaExecutionContexts** | Workflow/activity execution contexts | Scope data, expiration support |
| **ElsaApprovalInstances** | Approval task management | Requests, due dates, escalation |
| **ElsaWorkflowSuspensions** | Manual workflow suspensions | Suspension reasons, user tracking, resume timing |
| **ElsaAuditLogs** | Compliance audit trail | All CRUD operations, change tracking, user/IP logging |

## Monitoring & Reporting Views (16)

## Package Contents

### Core Tables

1. **ElsaWorkflowDefinitions.sql**
   - Stores workflow definitions and their metadata
   - Supports versioning, publishing, and multi-tenancy

2. **ElsaWorkflowDefinitionVersions.sql**
   - Tracks different versions of workflow definitions
   - Stores JSON workflow data and publishing information

3. **ElsaWorkflowInstances.sql**
   - Represents individual workflow executions
   - Tracks status, variables, and input/output data

4. **ElsaActivityExecutions.sql**
   - Records execution details for each activity within a workflow
   - Tracks status, outputs, and exceptions

5. **ElsaBookmarks.sql**
   - Stores bookmarks for workflow resumption points
   - Enables resumable and resuming workflows

6. **ElsaWorkflowExecutionLogs.sql**
   - Comprehensive audit trail for workflow executions
   - Logs workflow events and activity completions

7. **ElsaVariableInstances.sql**
   - Stores workflow variables and their values
   - Supports volatile and persisted variables

8. **ElsaTriggeredWorkflows.sql**
   - Manages workflows that are triggered by specific events
   - Supports timers, events, webhooks, and custom triggers

9. **ElsaWorkflowEvents.sql**
   - Stores events that occur within workflow instances
   - Tracks event processing status

10. **ElsaWorkflowTriggers.sql**
    - Stores trigger configurations for activities
    - Links activities to their trigger types

11. **ElsaExecutionContexts.sql**
    - Stores execution context data for workflow and activity scopes
    - Supports workflow, activity, and decision contexts

12. **ElsaApprovalInstances.sql**
    - Manages approval tasks within workflows
    - Tracks requesters, approvers, and approval status

13. **ElsaWorkflowSuspensions.sql**
    - Records manual suspensions and resumptions of workflows
    - Tracks reasons and notes for suspension

14. **ElsaAuditLogs.sql**
    - Complete audit trail for all workflow-related changes
    - Records who made what changes and when

### Configuration & Utility Files

- **Elsa.sql**
  - Main installation orchestrator
  - Executes all table creation scripts in correct order

- **ElsaIndexes.sql**
  - Creates additional indexes for performance optimization
  - Adds unique constraints where necessary

### Reporting & Monitoring Queries

- **ElsaWorkflowStatusOverview.sql**
  - Overview of all workflow statuses and percentages

- **ElsaRunningWorkflows.sql**
  - Lists currently running workflows and their duration

- **ElsaFaultedWorkflows.sql**
  - Displays workflows with faults and error messages

- **ElsaWorkflowExecutionStatistics.sql**
  - Workflow statistics including completion rates and average duration

- **ElsaActivityPerformance.sql**
  - Performance metrics for different activity types

- **ElsaPendingApprovals.sql**
  - Lists pending approvals with due dates

- **ElsaOverdueApprovals.sql**
  - Identifies overdue approvals for follow-up

- **ElsaSuspendedWorkflows.sql**
  - Shows suspended workflows and suspension details

- **ElsaExecutionLogsSummary.sql**
  - Summary of recent execution logs by event type

- **ElsaWorkflowDefinitionsStatus.sql**
  - Current status of all workflow definitions

- **ElsaRecentlyModifiedWorkflows.sql**
  - Recently updated workflow definitions

- **ElsaDatabaseSizeInformation.sql**
  - Database storage information for all Elsa tables

- **ElsaAuditLogRecentChanges.sql**
  - Recent audit log entries for compliance tracking

- **ElsaMultiTenantStatistics.sql**
  - Statistics broken down by tenant

- **ElsaVariablesUsage.sql**
  - Usage statistics for workflow variables

- **ElsaBookmarksStatus.sql**
  - Summary of bookmark processing status

## Installation

### Basic Installation

Run the main installation script:

```sql
USE YourDatabase;
GO
:r Elsa.sql
GO
```

### Individual Table Installation

To install specific tables:

```sql
USE YourDatabase;
GO
:r ElsaWorkflowDefinitions.sql
GO
:r ElsaWorkflowInstances.sql
GO
```

## Database Requirements

- **SQL Server Version**: 2019 or later
- **Compatibility Level**: 130 or higher
- **Authentication**: Windows or SQL Authentication
- **Default Schema**: dbo (customizable in scripts)

## Key Features

### Multi-Tenancy
- All major tables support `TenantId` for multi-tenant scenarios
- Isolation and data separation per tenant

### Audit Trail
- Complete audit logging of all changes
- Tracks user, IP address, timestamp, and change details

### Performance
- Optimized indexes on frequently queried columns
- Support for large-scale workflow execution

### Workflow Management
- Workflow definition versioning and publishing
- Support for paused, suspended, and deleted workflows

### Activity Tracking
- Detailed tracking of each activity execution
- Performance metrics and execution logs

### Approvals
- Built-in approval workflow support
- Deadline management and reminder system

## Monitoring and Management

Use the individual query scripts to monitor and manage your Elsa workflows:

### Status & Overview
- Run `ElsaWorkflowStatusOverview.sql` to see distribution of workflow statuses

### Active Workflows
- Run `ElsaRunningWorkflows.sql` to monitor currently executing workflows
- Run `ElsaSuspendedWorkflows.sql` to check suspended workflows

### Issues & Faults
- Run `ElsaFaultedWorkflows.sql` to identify failed workflows
- Run `ElsaAuditLogRecentChanges.sql` to track all recent changes

### Performance Analysis
- Run `ElsaWorkflowExecutionStatistics.sql` for overall performance metrics
- Run `ElsaActivityPerformance.sql` to analyze individual activity performance

### Approvals
- Run `ElsaPendingApprovals.sql` to see pending approvals
- Run `ElsaOverdueApprovals.sql` to identify overdue items

### System Health
- Run `ElsaDatabaseSizeInformation.sql` to check database growth
- Run `ElsaMultiTenantStatistics.sql` for multi-tenant overview
- Run `ElsaBookmarksStatus.sql` to check bookmark processing status

## Data Retention

Consider implementing a cleanup policy for old data:

```sql
-- Archives old workflow instances (90+ days old)
DELETE FROM [dbo].[ElsaWorkflowInstances]
WHERE [IsDeleted] = 1
    AND [DeletedAt] < DATEADD(DAY, -90, GETUTCDATE());

-- Archives old execution logs (180+ days old)
DELETE FROM [dbo].[ElsaWorkflowExecutionLogs]
WHERE [Timestamp] < DATEADD(DAY, -180, GETUTCDATE());
```

## Backup Recommendations

- **Frequency**: Daily or based on workflow volume
- **Retention**: Minimum 30 days for audit compliance
- **Type**: Full backup with transaction log backups every 15 minutes

## Quick Reference

Each query is available as a separate script:

### Running Queries

To run any monitoring query:

```sql
USE YourDatabase;
GO
:r ElsaRunningWorkflows.sql
GO
```

Or within SQL Server Management Studio, simply execute the script file directly.

### Query Organization

Queries are organized by object/purpose:
- `Elsa[ObjectName].sql` - Table/object creation scripts
- `Elsa[ObjectName]Status.sql` - Status monitoring queries
- `Elsa[ObjectName]Statistics.sql` - Performance analysis queries
- `Elsa[ObjectName]Usage.sql` - Usage metrics and tracking queries

## Troubleshooting

### Foreign Key Constraints
Ensure tables are created in the correct order. Use the main `Elsa.sql` script for proper sequencing.

### Index Issues
Run `ElsaIndexes.sql` to create any missing indexes for performance.

### Audit Log Size
Monitor and archive old audit logs to maintain performance.

## Support

For issues, questions, or contributions, please refer to the main Zync project documentation.

## Version History

- **3.0**: Initial SQL Server implementation with comprehensive workflow support


# Elsa 3.5.3 (SQL Server)

This package installs the Elsa workflow engine tables with the `Elsa` prefix into the `dbo` schema, along with supporting indexes and helpers for workflow task management.

## Tables Created

- `ElsaWorkflowDefinitions` – Workflow definition versions and metadata
- `ElsaWorkflowInstances` – Workflow execution instances
- `ElsaActivityInstances` – Activity execution records
- `ElsaBookmarks` – Bookmark data for workflow resumption
- `ElsaWorkflowExecutionLogRecords` – Execution log entries
- `ElsaLabels` – Label definitions
- `ElsaWorkflowDefinitionLabels` – Workflow-to-label mappings
- `ElsaStoredBookmarks` – Persisted bookmark trigger data
- `ElsaWorkflowTasks` – Human tasks created by workflows for approval, review, and user interactions

## Views

- `vw_ElsaMyPendingTasks` – View for retrieving pending tasks with due date information
- `vw_ElsaWorkflowTaskStats` – Task statistics by workflow definition

## Stored Procedures

- `sp_ElsaGetMyWorkflowTasks` – Retrieve user workflow tasks with pagination
- `sp_ElsaCompleteWorkflowTask` – Mark a task complete and return bookmark for workflow resumption

## Indexes

- Performance indexes on Status, AssignedTo, AssignedRole, InstanceId, DueDate, and CreatedAt

## Install

Via Zync:

```sql
EXEC DBO.Zync 'i Elsa';
```

Or individually:

```sql
EXEC DBO.Zync 'i Elsa/ElsaWorkflowTasks.sql';
EXEC DBO.Zync 'i Elsa/ElsaMyPendingTasks.sql';
EXEC DBO.Zync 'i Elsa/ElsaWorkflowTaskStats.sql';
EXEC DBO.Zync 'i Elsa/ElsaGetMyWorkflowTasks.sql';
EXEC DBO.Zync 'i Elsa/ElsaCompleteWorkflowTask.sql';
EXEC DBO.Zync 'i Elsa/ElsaIndexes.sql';
```

## Usage Examples

```sql
-- Get pending tasks for user
EXEC [dbo].[sp_ElsaGetMyWorkflowTasks] 'user@example.com', 'Pending', 1, 25;

-- Complete a task
EXEC [dbo].[sp_ElsaCompleteWorkflowTask] 
    @TaskId = '12345678-1234-1234-1234-123456789012',
    @UserId = 'user@example.com',
    @Outcome = 'Approved',
    @Comment = 'Task completed successfully';

-- Query pending tasks with overdue information
SELECT * FROM [dbo].[vw_ElsaMyPendingTasks] WHERE [IsOverdue] = 1;

-- Get task statistics by workflow
SELECT * FROM [dbo].[vw_ElsaWorkflowTaskStats];
```

# Elsa 3.5.3 (SQL Server)

This package installs the Elsa workflow engine tables with the `Elsa` prefix into the `dbo` schema, along with supporting indexes.

## Tables Created

- `ElsaWorkflowDefinitions` – Workflow definition versions and metadata
- `ElsaWorkflowInstances` – Workflow execution instances
- `ElsaActivityInstances` – Activity execution records
- `ElsaBookmarks` – Bookmark data for workflow resumption
- `ElsaWorkflowExecutionLogRecords` – Execution log entries
- `ElsaLabels` – Label definitions
- `ElsaWorkflowDefinitionLabels` – Workflow-to-label mappings
- `ElsaStoredBookmarks` – Persisted bookmark trigger data
- Indexes on key lookup columns for performance

## Install

Via Zync:

```sql
EXEC DBO.Zync 'i Elsa';
```

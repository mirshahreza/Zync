# 📊 DbMon Package

The `DbMon` package provides scripts for database monitoring and diagnostics.

## ♻️ Views vs Procedures
Most diagnostics and schema exploration utilities are now implemented as views for easier ad‑hoc querying and composition. Some remain procedures due to engine limitations (e.g., reading error logs) or for backward‑compatible wrappers.

Converted to views:
- ZzSelectActiveSessions
- ZzSelectAgentJobsStatus
- ZzSelectBlockingProcesses
- ZzSelectDatabaseGrowth
- ZzSelectExpensiveQueries
- ZzSelectIndexUsage
- ZzSelectServerConfiguration
- ZzSelectUnusedIndexes
- ZzSelectBackupHistory
- ZzSelectMissingIndexes
- ZzSelectFragmentedIndexes
- ZzSelectLongRunningQueries (threshold > 60s)
- ZzSelectOrphanedUsers (principals join)
- ZzSelectLogFileUsage (SQL Server 2019+)

Schema exploration (migrated from DbSel):
- ZzSelectObjectsDetails, ZzSelectObjectsOverview
- ZzSelectProceduresFunctionsParameters
- ZzSelectTablesIndexes, ZzSelectTablesOverview, ZzSelectTablesViewsColumns, ZzSelectTablesFks
- ZzSelectObjectDependencies, ZzSelectColumnDependencies
- ZzSelectDefaultConstraints, ZzSelectCheckConstraints, ZzSelectUniqueAndPKConstraints
- ZzSelectIdentityColumns, ZzSelectExtendedProperties, ZzSelectTriggers

Still procedures (and why):
- ZzSelectFailedLogins — relies on `sp_readerrorlog` which cannot be used inside a view.

Wrappers removed:
- `ZzSelectObjectDependenciesProc`
- `ZzSelectColumnDependenciesProc`

For filtering, query the companion views directly:
- `ZzSelectObjectDependencies`
- `ZzSelectColumnDependencies`

If you want any of the remaining items as views, we can add companion views with sensible defaults (e.g., last 30 days) and keep the procs for parameterized filtering.

<!-- TVF for object dependencies removed: ZzFnObjectDependencies -->

## 🚀 Deployment

To deploy all scripts in the `DbMon` package:
```sql
EXEC dbo.Zync 'i DbMon'
```
Alternatively:
```sql
EXEC dbo.Zync 'i DbMon/.sql'
```

Notes:
- Prefer running the installer script (`DbMon/.sql`) to ensure dependent views (e.g., those relying on `ZzSelectObjectsDetails`) are created in the right order.
- `ZzSelectLogFileUsage` requires SQL Server 2019+ (uses `sys.dm_db_log_stats`).
- Some DMVs require appropriate permissions (e.g., `VIEW SERVER STATE`).

## Included utilities
- Active sessions and blocking processes
- Backup history and Agent jobs status
- Index fragmentation and usage analysis
- Expensive/long-running queries
- Log file usage, growth, and more
- Full schema exploration (migrated from DbSel)

### New (2025-09-29)
- ZzSelectWaitStats — Aggregate Wait Stats with categories and percent share
- ZzSelectTempdbUsage — TempDB usage by session and internal objects
- ZzSelectFileStats — File I/O stats and size/free space

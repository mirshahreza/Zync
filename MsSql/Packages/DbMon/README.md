# 📊 DbMon Package

The `DbMon` package provides scripts for database monitoring and diagnostics.

## ♻️ Views vs Procedures
Most diagnostics here are now implemented as views for easier ad-hoc querying and composition. Some remain procedures due to engine limitations (parameters, DBCC/EXEC requirements, or version branching).

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

Still procedures (and why):
- ZzSelectFailedLogins — relies on `sp_readerrorlog` which cannot be used inside a view.

If you want any of the remaining items as views, we can add companion views with sensible defaults (e.g., last 30 days) and keep the procs for parameterized filtering.

## 🚀 Deployment

To deploy all scripts in the `DbMon` package:
```sql
EXEC dbo.Zync 'i DbMon'
```
Alternatively:
```sql
EXEC dbo.Zync 'i DbMon/.sql'
```

## � Included Utilities
- Active sessions and blocking processes
- Backup history and Agent jobs status
- Index fragmentation and usage analysis
- Expensive/long-running queries
- Log file usage, growth, and more

# 📊 DbMon Package

The `DbMon` package provides a collection of scripts for database monitoring and diagnostics.

## 🚀 Deployment

### Deploy All Scripts
To deploy all scripts in the `DbMon` package, run the following command:
```sql
EXEC dbo.Zync 'i DbMon'
```
Alternatively, you can use:
```sql
EXEC dbo.Zync 'i DbMon/.sql'
```

## 📜 Scripts

This package includes utilities for:
- Viewing active sessions and blocking processes.
- Checking backup history and agent job status.
- Analyzing index fragmentation and usage.
- Identifying expensive or long-running queries.
- And more.

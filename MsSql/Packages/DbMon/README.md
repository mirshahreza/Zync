# 📊 DbMon Package

The `DbMon` package provides scripts for database monitoring and diagnostics.

## 🚀 Deployment

To deploy all scripts in the `DbMon` package:
```sql
EXEC dbo.Zync 'i DbMon'
```
Alternatively:
```sql
EXEC dbo.Zync 'i DbMon/.sql'
```

## 📜 Included Utilities
- Active sessions and blocking processes
- Backup history and Agent jobs status
- Index fragmentation and usage analysis
- Expensive/long-running queries
- Log file usage, growth, and more

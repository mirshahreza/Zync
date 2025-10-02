# 💾 Backup Package

The `Backup` package provides a collection of functions and procedures for database backup operations, table archiving, and data recovery utilities.

## 🚀 Deployment

To deploy all scripts in the `Backup` package:
```sql
EXEC dbo.Zync 'i Backup'
```
Alternatively:
```sql
EXEC dbo.Zync 'i Backup/.sql'
```

## 📜 Included Utilities

- ZzBackupTable: Create backup copy of a table with timestamp
	- Example: `EXEC [dbo].[ZzBackupTable] 'Users', 'UserBackups';`
- ZzRestoreTable: Restore table from backup
	- Example: `EXEC [dbo].[ZzRestoreTable] 'UserBackups_20241002', 'Users';`
- ZzCreateBackupScript: Generate backup script for table structure and data
	- Example: `SELECT [dbo].[ZzCreateBackupScript]('Users', 1);`
- ZzGetBackupInfo: Get information about existing table backups
	- Example: `SELECT * FROM [dbo].[ZzGetBackupInfo]('Users');`
- ZzVerifyBackup: Verify backup integrity and row counts
	- Example: `SELECT [dbo].[ZzVerifyBackup]('Users', 'UserBackups_20241002');`
- ZzCleanupOldBackups: Remove old backup tables based on retention policy
	- Example: `EXEC [dbo].[ZzCleanupOldBackups] 'UserBackups', 30;`
- ZzExportTableToCSV: Generate CSV export script for table data
	- Example: `SELECT [dbo].[ZzExportTableToCSV]('Users', 'C:\Exports\');`

Notes:
- `ls Backup` shows each item with its short description taken from a `-- Description:` line at the top of the script.
- Backup tables are created with timestamp suffixes
- Functions support both structure and data backup operations
- Includes cleanup and verification utilities for backup management
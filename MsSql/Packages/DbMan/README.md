# 🛠️ DbMan Package

The `DbMan` package provides scripts for database structure management and manipulation.

## 🚀 Deployment

To deploy all scripts in the `DbMan` package:
```sql
EXEC dbo.Zync 'i DbMan'
```
Alternatively:
```sql
EXEC dbo.Zync 'i DbMan/.sql'
```

## 📜 Included Utilities
- Create/alter/drop tables, columns, and constraints
- Rename database objects
- Truncate tables
- Foreign key management
- Object existence helpers
- And more

Notes:
- Prefer installing via `DbMan/.sql` to ensure the correct creation order for dependent items.
- `ls DbMan` shows each item with its short description taken from a `-- Description:` line at the top of the script.

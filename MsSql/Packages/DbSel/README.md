# 🔍 DbSel Package

The `DbSel` package provides scripts for querying and displaying database schema and structure information.

## 🚀 Deployment

To deploy all scripts in the `DbSel` package:
```sql
EXEC dbo.Zync 'i DbSel'
```
Alternatively:
```sql
EXEC dbo.Zync 'i DbSel/.sql'
```

## 📜 Included Utilities (View-only)
- List tables, views, procedures, and functions
- Show columns, indexes, constraints (PK/Unique/Check/Default) and foreign keys
- Identity columns, triggers, extended properties
- Object and column dependencies
- Schema exploration helpers

All utilities are exposed as views under [dbo].[ZzSelect...]. Filter با WHERE برای سناریوهای خاص به‌جای EXEC توصیه می‌شود.

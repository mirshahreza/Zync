# 🔤 String Package

The `String` package provides a collection of functions for common string manipulations.

## 🚀 Deployment

To deploy all scripts in the `String` package:
```sql
EXEC dbo.Zync 'i String'
```
Alternatively:
```sql
EXEC dbo.Zync 'i String/.sql'
```

## 📜 Included Utilities
- Split strings by a delimiter
- Count words/characters and substring occurrences
- Trim and normalize text
- Case transformations (camel/snake, etc.)
- Misc string helpers (masking, soundex, similarity, slugify, ...)

Notes:
- `ls String` shows each item with its short description taken from a `-- Description:` line at the top of the script.

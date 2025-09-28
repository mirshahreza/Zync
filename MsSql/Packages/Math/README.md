# 🔢 Math Package

The `Math` package provides helper functions for numeric formatting and calculations.

## 🚀 Deployment

To deploy all scripts in the `Math` package:
```sql
EXEC dbo.Zync 'i Math'
```
Alternatively:
```sql
EXEC dbo.Zync 'i Math/.sql'
```

## 📜 Included Utilities
- Format byte sizes (KB, MB, GB)
- Humanize numbers
- Statistical helpers (e.g., standard deviation)
- Conversions (binary/hex/roman)
- Misc math helpers (safe divide, rounding, random, ...)

Notes:
- `ls Math` shows each item with its short description taken from a `-- Description:` line at the top of the script.

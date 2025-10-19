# 📅 DateTime Package

The `DateTime` package provides a collection of functions for advanced date and time manipulations.

## 🚀 Deployment

To deploy all scripts in the `DateTime` package:
```sql
EXEC dbo.Zync 'i DateTime'
```
Alternatively:
```sql
EXEC dbo.Zync 'i DateTime/.sql'
```

## 📜 Included Utilities
- Hijri and Shamsi calendar conversions
- Date and time formatting
- Start/end of day, week, month, year calculations
- Working/business day calculations
- Other date/time helpers

Notes:
- `ls DateTime` shows each item with its short description taken from a `-- Description:` line at the top of the script.

### New (2025-09-29)
- ZzISOWeekNumber — Week number in ISO-8601 format

### Advanced Functions (2025-09-30)
- ZzConvertToLunar — Convert Gregorian date to Islamic lunar
- ZzHolidayChecker — Check official holidays in Iran and other countries
- ZzBusinessDaysCalculator — Calculate business days considering holidays
- ZzTimeZoneConverter — Convert time across time zones
- ZzScheduleGenerator — Generate work schedules with various patterns
- ZzDateValidator — Validate dates across different calendars
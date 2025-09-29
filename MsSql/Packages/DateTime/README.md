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
- ZzISOWeekNumber — شماره هفته به‌صورت ISO-8601

### Advanced Functions (2025-09-30)
- ZzConvertToLunar — تبدیل تاریخ میلادی به قمری اسلامی
- ZzHolidayChecker — بررسی تعطیلات رسمی ایران و سایر کشورها
- ZzBusinessDaysCalculator — محاسبه روزهای کاری با در نظر گیری تعطیلات
- ZzTimeZoneConverter — تبدیل زمان بین مناطق زمانی مختلف
- ZzScheduleGenerator — تولید برنامه‌های کاری با الگوهای مختلف
- ZzDateValidator — اعتبارسنجی تاریخ در تقویم‌های مختلف
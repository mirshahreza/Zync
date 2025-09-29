-- راه حل ساده و مستقیم برای پاک کردن همه آبجکت‌های Zz*
-- این اسکریپت بدون وابستگی به Zync کار می‌کند

PRINT '=== شروع پاک‌سازی دستی آبجکت‌های Zz* ==='
PRINT ''

-- Step 1: پاک کردن همه PROCEDURE ها
PRINT '--- پاک کردن PROCEDUREها ---'
DECLARE @sql NVARCHAR(MAX) = ''
SELECT @sql = @sql + 'DROP PROCEDURE [dbo].[' + name + ']' + CHAR(13) + CHAR(10)
FROM sys.objects 
WHERE name LIKE 'Zz%' AND type = 'P'

IF LEN(@sql) > 0
BEGIN
    PRINT 'PROCEDUREهای پیدا شده:'
    PRINT @sql
    EXEC sp_executesql @sql
    PRINT 'همه PROCEDUREها پاک شدند.'
END
ELSE
    PRINT 'هیچ PROCEDUREای پیدا نشد.'

PRINT ''

-- Step 2: پاک کردن همه FUNCTIONها
PRINT '--- پاک کردن FUNCTIONها ---'
SET @sql = ''
SELECT @sql = @sql + 'DROP FUNCTION [dbo].[' + name + ']' + CHAR(13) + CHAR(10)
FROM sys.objects 
WHERE name LIKE 'Zz%' AND type IN ('FN', 'TF', 'IF')

IF LEN(@sql) > 0
BEGIN
    PRINT 'FUNCTIONهای پیدا شده:'
    PRINT @sql
    EXEC sp_executesql @sql
    PRINT 'همه FUNCTIONها پاک شدند.'
END
ELSE
    PRINT 'هیچ FUNCTIONای پیدا نشد.'

PRINT ''

-- Step 3: پاک کردن همه VIEWها
PRINT '--- پاک کردن VIEWها ---'
SET @sql = ''
SELECT @sql = @sql + 'DROP VIEW [dbo].[' + name + ']' + CHAR(13) + CHAR(10)
FROM sys.objects 
WHERE name LIKE 'Zz%' AND type = 'V'

IF LEN(@sql) > 0
BEGIN
    PRINT 'VIEWهای پیدا شده:'
    PRINT @sql
    EXEC sp_executesql @sql
    PRINT 'همه VIEWها پاک شدند.'
END
ELSE
    PRINT 'هیچ VIEWای پیدا نشد.'

PRINT ''

-- Step 4: پاک کردن همه TYPEها
PRINT '--- پاک کردن TYPEها ---'
SET @sql = ''
SELECT @sql = @sql + 'DROP TYPE [dbo].[' + name + ']' + CHAR(13) + CHAR(10)
FROM sys.types 
WHERE name LIKE 'Zz%' AND is_user_defined = 1

IF LEN(@sql) > 0
BEGIN
    PRINT 'TYPEهای پیدا شده:'
    PRINT @sql
    EXEC sp_executesql @sql
    PRINT 'همه TYPEها پاک شدند.'
END
ELSE
    PRINT 'هیچ TYPEای پیدا نشد.'

PRINT ''

-- Step 5: پاکسازی جداول tracking
PRINT '--- پاکسازی جداول tracking ---'
IF OBJECT_ID('[dbo].[ZyncObjects]') IS NOT NULL
BEGIN
    DELETE FROM [dbo].[ZyncObjects]
    PRINT 'جدول ZyncObjects پاک شد.'
END

IF OBJECT_ID('[dbo].[ZyncPackages]') IS NOT NULL
BEGIN
    DELETE FROM [dbo].[ZyncPackages]
    PRINT 'جدول ZyncPackages پاک شد.'
END

PRINT ''
PRINT '=== پاک‌سازی کامل شد! ==='
PRINT 'لطفاً اسکریپت diagnostic_check.sql را اجرا کنید تا مطمئن شوید همه چیز پاک شده.'
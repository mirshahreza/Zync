-- Simple and direct solution to remove all Zz* objects
-- This script works independently of Zync

PRINT '=== Starting manual cleanup of Zz* objects ==='
PRINT ''

-- Step 1: Drop all PROCEDUREs
PRINT '--- Dropping PROCEDUREs ---'
DECLARE @sql NVARCHAR(MAX) = ''
SELECT @sql = @sql + 'DROP PROCEDURE [dbo].[' + name + ']' + CHAR(13) + CHAR(10)
FROM sys.objects 
WHERE name LIKE 'Zz%' AND type = 'P'

IF LEN(@sql) > 0
BEGIN
    PRINT 'Found PROCEDUREs:'
    PRINT @sql
    EXEC sp_executesql @sql
    PRINT 'All PROCEDUREs were dropped.'
END
ELSE
    PRINT 'No PROCEDUREs were found.'

PRINT ''

-- Step 2: Drop all FUNCTIONs
PRINT '--- Dropping FUNCTIONs ---'
SET @sql = ''
SELECT @sql = @sql + 'DROP FUNCTION [dbo].[' + name + ']' + CHAR(13) + CHAR(10)
FROM sys.objects 
WHERE name LIKE 'Zz%' AND type IN ('FN', 'TF', 'IF')

IF LEN(@sql) > 0
BEGIN
    PRINT 'Found FUNCTIONs:'
    PRINT @sql
    EXEC sp_executesql @sql
    PRINT 'All FUNCTIONs were dropped.'
END
ELSE
    PRINT 'No FUNCTIONs were found.'

PRINT ''

-- Step 3: Drop all VIEWs
PRINT '--- Dropping VIEWs ---'
SET @sql = ''
SELECT @sql = @sql + 'DROP VIEW [dbo].[' + name + ']' + CHAR(13) + CHAR(10)
FROM sys.objects 
WHERE name LIKE 'Zz%' AND type = 'V'

IF LEN(@sql) > 0
BEGIN
    PRINT 'Found VIEWs:'
    PRINT @sql
    EXEC sp_executesql @sql
    PRINT 'All VIEWs were dropped.'
END
ELSE
    PRINT 'No VIEWs were found.'

PRINT ''

-- Step 4: Drop all TYPEs
PRINT '--- Dropping TYPEs ---'
SET @sql = ''
SELECT @sql = @sql + 'DROP TYPE [dbo].[' + name + ']' + CHAR(13) + CHAR(10)
FROM sys.types 
WHERE name LIKE 'Zz%' AND is_user_defined = 1

IF LEN(@sql) > 0
BEGIN
    PRINT 'Found TYPEs:'
    PRINT @sql
    EXEC sp_executesql @sql
    PRINT 'All TYPEs were dropped.'
END
ELSE
    PRINT 'No TYPEs were found.'

PRINT ''

-- Step 5: Clean up tracking tables
PRINT '--- Cleaning tracking tables ---'
IF OBJECT_ID('[dbo].[ZyncObjects]') IS NOT NULL
BEGIN
    DELETE FROM [dbo].[ZyncObjects]
    PRINT 'Table ZyncObjects cleared.'
END

IF OBJECT_ID('[dbo].[ZyncPackages]') IS NOT NULL
BEGIN
    DELETE FROM [dbo].[ZyncPackages]
    PRINT 'Table ZyncPackages cleared.'
END

PRINT ''
PRINT '=== Cleanup completed! ==='
PRINT 'Please run diagnostic_check.sql to ensure everything is removed.'

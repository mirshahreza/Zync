-- Manual cleanup script for all Zync objects
PRINT 'Manual cleanup of all Zync objects starting...'

-- Drop all procedures starting with Zz
DECLARE @sql NVARCHAR(MAX) = ''

SELECT @sql = @sql + 'DROP PROCEDURE [' + SCHEMA_NAME(schema_id) + '].[' + name + '];' + CHAR(13)
FROM sys.objects 
WHERE name LIKE 'Zz%' AND type = 'P'

PRINT 'Dropping procedures...'
IF LEN(@sql) > 0
BEGIN
    EXEC sp_executesql @sql
    PRINT 'Procedures dropped.'
END
ELSE
    PRINT 'No procedures found.'

-- Drop all functions starting with Zz  
SET @sql = ''
SELECT @sql = @sql + 'DROP FUNCTION [' + SCHEMA_NAME(schema_id) + '].[' + name + '];' + CHAR(13)
FROM sys.objects 
WHERE name LIKE 'Zz%' AND type IN ('FN', 'TF', 'IF')

PRINT 'Dropping functions...'
IF LEN(@sql) > 0
BEGIN
    EXEC sp_executesql @sql
    PRINT 'Functions dropped.'
END
ELSE
    PRINT 'No functions found.'

-- Drop all views starting with Zz
SET @sql = ''
SELECT @sql = @sql + 'DROP VIEW [' + SCHEMA_NAME(schema_id) + '].[' + name + '];' + CHAR(13)
FROM sys.objects 
WHERE name LIKE 'Zz%' AND type = 'V'

PRINT 'Dropping views...'
IF LEN(@sql) > 0
BEGIN
    EXEC sp_executesql @sql
    PRINT 'Views dropped.'
END
ELSE
    PRINT 'No views found.'

-- Drop all types starting with Zz
SET @sql = ''
SELECT @sql = @sql + 'DROP TYPE [' + SCHEMA_NAME(schema_id) + '].[' + name + '];' + CHAR(13)
FROM sys.types 
WHERE name LIKE 'Zz%' AND is_user_defined = 1

PRINT 'Dropping types...'
IF LEN(@sql) > 0
BEGIN
    EXEC sp_executesql @sql
    PRINT 'Types dropped.'
END
ELSE
    PRINT 'No types found.'

-- Clean tracking tables
DELETE FROM [dbo].[ZyncObjects];
DELETE FROM [dbo].[ZyncPackages];

PRINT 'Tracking tables cleared.'
PRINT 'Manual cleanup completed!'

-- Verify cleanup
PRINT 'Remaining Zync objects:'
SELECT name, type_desc FROM sys.objects WHERE name LIKE 'Zz%'
UNION ALL
SELECT name, 'USER_DEFINED_TYPE' FROM sys.types WHERE name LIKE 'Zz%' AND is_user_defined = 1